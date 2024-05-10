extends CharacterBody2D

const DASH_SPEED = 1200
const DASH_UP = -600
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const DOUBLE_JUMP_VELOCITY = -400.0

@onready var cshape = $CollisionShape2D
@onready var anim = get_node("AnimationPlayer")
@onready var particles = $GPUParticles2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2
@export var ghost_node: PackedScene
@onready var ghost_timer = $GhostTimer
var dashing = false

var is_crouching = false
var stuck_under_object = false
var has_double_jumped = false
var standing_cshape = preload("res://Assets/Collisions/player_standing_cshape.tres")
var crouching_cshape = preload("res://Assets/Collisions/player_crouching_cshape.tres")
var is_attacking
var is_interaction
var is_dead
var is_hurt
var is_dying = false


func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(global_position, $AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(ghost)


func dash():
	particles.emitting = true
	$GhostSpawnTimer.start()
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.DASH)


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	print(anim.current_animation)
	if not is_on_floor():
		velocity.y += gravity * delta
	is_dead = GlobalVariables.CURRENT_HEALTH == 0
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
		move_and_slide()

	if GlobalVariables.PLAYER_CONTROLS_ENABLED and not is_dying:
		var direction = Input.get_axis("ui_left", "ui_right")
		#Handle dash
		if Input.is_action_just_pressed("Dash") and GlobalVariables.CAN_PLAYER_DASH:
			if direction:
				dash()
				dashing = true
				# mozna tu wrzucic animacje dasha
				GlobalVariables.CAN_PLAYER_DASH = false
				ghost_timer.start()
				$dash_again_timer.start()
		else:
			#Crouch
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
					if stuck_under_object != true:
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
			move_and_slide()
	elif not GlobalVariables.PLAYER_CONTROLS_ENABLED:
		anim.play("Idle")
	#


func above_head_is_empty() -> bool:
	var result = !crouch_raycast1.is_colliding() and !crouch_raycast2.is_colliding()
	return result


func is_idle() -> bool:
	if anim.current_animation == "Idle":
		return true
	return false


func update_animations(direction, dir):
	print(anim.current_animation)
	if Input.is_action_pressed("Interact") and (is_idle() or anim.current_animation == "Run"):
		#GlobalVariables.PLAYER_CONTROLS_ENABLED = false;
		#print("x")
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
			#print("Jump")
	#if velocity.x == 0 and velocity.y == 0 and is_attacking:
	#anim.play("Attack")
	if Input.is_action_just_pressed("Attack") and !is_interaction and !is_hurt:
		if is_crouching == false:
			if dir == false:
				if velocity.y != 0:
					anim.play("Attack_Jump")
				else:
					if velocity.x != 0:
						anim.play("Attack_Run")
					else:
						anim.play("Attack")
			else:
				if velocity.y != 0:
					anim.play("Attack_Jump_L")
				else:
					if velocity.x != 0:
						anim.play("Attack_Run_L")
					else:
						anim.play("attack_left")

	if Input.is_action_just_pressed("Jump") and not has_double_jumped and not is_on_floor():
		velocity.y = DOUBLE_JUMP_VELOCITY
		anim.play("Jump")
		#print("Doublejump")
		has_double_jumped = true

	if is_on_floor():
		has_double_jumped = false

	if direction and anim.current_animation != "Interact" and !is_hurt:
		if dashing:
			velocity.y = 0
			velocity.x = direction * DASH_SPEED
		else:
			if is_crouching:
				velocity.x = direction * SPEED * 0.5
			else:
				velocity.x = direction * SPEED
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
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
	if body.is_in_group("enemy"):
		print("Hit enemy")
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SLASH_METAL)
		body.get_parent().queue_free()
	pass


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
		if GlobalVariables.CURRENT_HEALTH != 0:
			anim.play("Hurt")
			GlobalVariables.CURRENT_HEALTH -= 1
			print("Getting hit", GlobalVariables.CURRENT_HEALTH)
	pass  # Replace with function body.
