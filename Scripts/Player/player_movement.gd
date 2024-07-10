extends CharacterBody2D

const DASH_SPEED = 1200

const JUMP_VELOCITY = -500.0
const DOUBLE_JUMP_VELOCITY = -400.0
const KNOCKBACK_POWER = 400

@onready var cshape = $CollisionShape2D
@onready var anim = get_node("AnimationPlayer")
@onready var particles = $GPUParticles2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2
@export var ghost_node: PackedScene
@onready var ghost_timer = $GhostTimer
var dashing = false
var dashDirection = Vector2.ZERO

var is_crouching = false
var stuck_under_object = false
var has_double_jumped = false
var standing_cshape = preload("res://Assets/Collisions/player_standing_cshape.tres")
var crouching_cshape = preload("res://Assets/Collisions/player_crouching_cshape.tres")
var is_attacking
var is_interaction
var is_hurt
var is_dying = false

var hp_regen_timer_flag = false

var shield_timer_flag = false
var is_shield_implant_active = false
var is_shield_up = false
@onready var vignette_rect = $Vignette
func _ready():
	dashDirection = Vector2(1, 0)
	print(self.get_path())
	preserve_inventory()

func add_ghost():
	var frameIndex: int = $AnimatedSprite2D.get_frame()
	var animationName: String = $AnimatedSprite2D.animation
	var spriteFrames: SpriteFrames = $AnimatedSprite2D.get_sprite_frames()
	var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
	var ghost = ghost_node.instantiate()
	ghost.set_property(global_position, $AnimatedSprite2D.scale, currentTexture, dashDirection)
	get_tree().current_scene.add_child(ghost)


func dash():
	particles.emitting = true
	$GhostSpawnTimer.start()
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.DASH)


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if GlobalVariables.CURRENT_LEVEL == 2:
		vignette_rect.visible = true
	else:
		vignette_rect.visible = false	
	if not is_on_floor():
		velocity.y += gravity * delta
	is_hurt = anim.current_animation == "Hurt"
	is_attacking = (
		anim.current_animation == "Attack"
		or anim.current_animation == "attack_left"
		or anim.current_animation == "Attack_Jump"
		or anim.current_animation == "Attack_Run"
		or anim.current_animation == "Attack_Run_L"
		or anim.current_animation == "Attack_Jump_L"
	)
	is_interaction = anim.current_animation == "Interact"

	if GlobalVariables.CURRENT_HEALTH == 0:
		if !is_dying:
			anim.play("Death")
		is_dying = true
		if anim.current_animation != "Death":
			GlobalVariables.CURRENT_HEALTH = GlobalVariables.MAX_HEALTH
			get_tree().reload_current_scene()
		velocity.x = sign(velocity.x) * KNOCKBACK_POWER/2
		if is_on_floor():
			velocity.x = 0
		move_and_slide()
		return

	if GlobalVariables.PLAYER_CONTROLS_ENABLED:
		var direction = Input.get_axis("ui_left", "ui_right")
		if Input.is_action_pressed("ui_right") and !dashing:
			dashDirection = Vector2(1, 0)
		elif Input.is_action_pressed("ui_left") and !dashing:
			dashDirection = Vector2(-1, 0)

		if Input.is_action_just_pressed("Dash") and GlobalVariables.CAN_PLAYER_DASH:
			if dashDirection:
				dash()
				dashing = true
				# mozna tu wrzucic animacje dasha
				GlobalVariables.CAN_PLAYER_DASH = false
				ghost_timer.start()
				$dash_again_timer.start()
		else:
			if (
				Input.is_action_pressed("Crouch")
				and is_on_floor()
				and !is_interaction
				and is_idle()
			):
				crouch()
			elif Input.is_action_just_released("Crouch") or !is_on_floor():
				if above_head_is_empty():
					stand()
				else:
					stuck_under_object = true
			# Add the gravity.
			if stuck_under_object and above_head_is_empty():
				stand()
				stuck_under_object = false

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.

			var dir = get_node("AnimatedSprite2D").flip_h
			if !is_interaction and !is_hurt:
				if direction == -1:
					get_node("AnimatedSprite2D").flip_h = true
				elif direction == 1:
					get_node("AnimatedSprite2D").flip_h = false
				# Handle jump.

			update_animations(direction, dir)
			check_for_implants()
			move_and_slide()
	elif not GlobalVariables.PLAYER_CONTROLS_ENABLED:
		anim.play("Idle")
	#

#=========================================================
#=========================================================

func above_head_is_empty() -> bool:
	var result = !crouch_raycast1.is_colliding() and !crouch_raycast2.is_colliding()
	return result


func is_idle() -> bool:
	if anim.current_animation == "Idle":
		return true
	return false

enum AttackEnum {ATTACK_JUMP,ATTACK_RUN,ATTACK}

func update_animations(direction, dir):
	if Input.is_action_pressed("Interact") and (is_idle() or anim.current_animation == "Run"):
		#GlobalVariables.PLAYER_CONTROLS_ENABLED = false;
		anim.play("Interact")

	if (
		Input.is_action_pressed("Jump")
		and is_on_floor()
		and (!is_crouching and above_head_is_empty())
		and !is_interaction
		and !is_hurt
	):
		velocity.y = JUMP_VELOCITY
		if !is_attacking:
			anim.play("Jump")
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.JUMP)

	const attack_anim_lut = [["Attack_Jump","Attack_Run","Attack"],["Attack_Jump_L","Attack_Run_L","attack_left"]]
	
	if Input.is_action_just_pressed("Attack") and !is_interaction and !is_hurt and !is_crouching:
		if velocity.y != 0:
			anim.play(attack_anim_lut[int(dir)][AttackEnum.ATTACK_JUMP])
		elif velocity.x != 0:
			anim.play(attack_anim_lut[int(dir)][AttackEnum.ATTACK_RUN])
		else:
			anim.play(attack_anim_lut[int(dir)][AttackEnum.ATTACK])

	if is_on_floor():
		has_double_jumped = false

	if anim.current_animation != "Interact" and !is_hurt:
		if dashing:
			velocity.y = 0
			#velocity.x = direction * DASH_SPEED
			velocity = dashDirection.normalized() * DASH_SPEED
			
	if direction and anim.current_animation != "Interact" and !is_hurt:
		if dashing:
			velocity.y = 0
			#velocity.x = direction * DASH_SPEED
			velocity = dashDirection.normalized() * DASH_SPEED
		else:
			if is_crouching:
				velocity.x = direction * GlobalVariables.PLAYER_SPEED * 0.5
			else:
				velocity.x = direction * GlobalVariables.PLAYER_SPEED
			if (
				(velocity.y == 0)
				and !anim.current_animation == "Attack_Run"
				and !anim.current_animation == "Attack_Run_L"
			):
				if is_crouching:
					anim.play("Crouch_walk")
				elif (
					anim.current_animation != "Hurt"
					and anim.current_animation != "Attack_Run"
					and !anim.current_animation == "Attack_Run_L"
				):
					anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, GlobalVariables.PLAYER_SPEED)
		if (
			(velocity.y == 0)
			and anim.current_animation != "Attack"
			and anim.current_animation != "attack_left"
		):
			if is_crouching:
				anim.play("Crouch")
			elif (
				!is_interaction
				and !is_hurt
				and anim.current_animation != "Interact"
				and !is_attacking
			):
				anim.play("Idle")
	if (
		(velocity.y > 0)
		and !anim.current_animation == "Attack_Jump"
		and !anim.current_animation == "Attack_Jump_L"
		and !is_hurt
	):
		anim.play("Fall")

func check_for_implants():
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == "Ultra Elastic Joints":
			if implant.equipped:
				if Input.is_action_just_pressed("Jump") and not has_double_jumped and not is_on_floor():
					velocity.y = DOUBLE_JUMP_VELOCITY
					anim.play("Jump")
					SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.DOUBLE_JUMP)
					has_double_jumped = true
		if implant.name == "Circulatory System Enhancement":
			if implant.equipped and !hp_regen_timer_flag:
				$HPRegenTimer.start()
				hp_regen_timer_flag = true
			if !implant.equipped:
				$HPRegenTimer.stop()
		if implant.name == "Light Titanium Leg Bones":
			if implant.equipped:
				GlobalVariables.PLAYER_SPEED = 500
			else:
				GlobalVariables.PLAYER_SPEED = 300
		if implant.name == "Ribcage Energy Shield":
			if implant.equipped and !shield_timer_flag:
				is_shield_implant_active = true
				$RechargableShieldTimer.start()
				shield_timer_flag = true
			if !implant.equipped:
				is_shield_implant_active = false
				shield_timer_flag = false
				is_shield_up = false
				$RechargableShieldTimer.stop()

func is_anim_playing() -> bool:
	if anim.current_animation != "Idle":
		return true
	return false


func crouch():
	if is_crouching:
		return
	if is_on_floor() and !is_anim_playing():
		is_crouching = true
		cshape.shape = crouching_cshape
		cshape.position.y = 5


func stand():
	if is_crouching == false:
		return
	is_crouching = false
	cshape.shape = standing_cshape
	cshape.position.y = -1


func _on_weapon_area_2d_body_entered(body):
	if body.is_in_group("metal_enemy"):
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SLASH_METAL)
		if body.has_method("take_damage"):
			body.take_damage(1)
		
	if body.is_in_group("flesh_enemy"):
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SLASH_FLESH)
		if body.has_method("take_damage"):
			body.take_damage(1)


func _on_ghost_timer_timeout():
	dashing = false
	particles.emitting = false


func _on_dash_again_timer_timeout():
	GlobalVariables.CAN_PLAYER_DASH = true


func _on_ghost_spawn_timer_timeout():
	if dashing:
		add_ghost()


func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		if (GlobalVariables.CURRENT_HEALTH != 0
		and (!is_shield_up or !is_shield_implant_active)):
			knockback()
			anim.play("Hurt")
			GlobalVariables.CURRENT_HEALTH -= 1
			print("Getting hit: ", GlobalVariables.CURRENT_HEALTH, " hp left")
			
		if is_shield_up:
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SHIELD_DISCHARGE)
			$AnimatedSprite2D.material.set_shader_parameter("effect_enabled", false)
		is_shield_up = false
		if is_shield_implant_active:
			$RechargableShieldTimer.start()
			shield_timer_flag = false

func knockback():
	velocity.x = sign(velocity.x) * (-1.0) * KNOCKBACK_POWER *3
	velocity.y = sign(velocity.y) * (-1.0) * KNOCKBACK_POWER
	move_and_slide()


func _on_hp_regen_timer_timeout():
	if GlobalVariables.CURRENT_HEALTH < GlobalVariables.MAX_HEALTH:
		GlobalVariables.CURRENT_HEALTH += 1
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HEAL)
	hp_regen_timer_flag = false

func _on_rechargable_shield_timer_timeout():
	is_shield_up = true
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SHIELD_CHARGED)
	$AnimatedSprite2D.material.set_shader_parameter("effect_enabled", true)
	$RechargableShieldTimer.stop()

func preserve_inventory():
	for implant in GlobalVariables.IMPLANTS:
		if implant.equipped:
			GlobalVariables.item_equip_signal.emit(implant.name)
		elif implant.posessed and !implant.equipped:
			GlobalVariables.item_pickup_signal.emit(implant.name)
