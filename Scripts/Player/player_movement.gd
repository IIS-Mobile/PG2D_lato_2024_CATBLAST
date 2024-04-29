extends CharacterBody2D

const DASH_SPEED = 1500
const DASH_UP = -600
const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var katanaSlashMetal: AudioStream = load("res://Assets/Sounds/player/slash against metal - mixkit.wav")
@onready var dashSound: AudioStream = load("res://Assets/Sounds/player/dash - danlew69.wav")
@onready var cshape = $CollisionShape2D
@onready var anim = get_node("AnimationPlayer")
@onready var particles = $GPUParticles2D
@onready var crouch_raycast1 = $CrouchRaycast_1
@onready var crouch_raycast2 = $CrouchRaycast_2
@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
var dashing = false
var can_dash = true
var is_crouching = false
var stuck_under_object = false
var standing_cshape = preload("res://Assets/Collisions/player_standing_cshape.tres")
var crouching_cshape = preload("res://Assets/Collisions/player_crouching_cshape.tres")
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(global_position, $AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(ghost)


func dash():
	particles.emitting = true
	$GhostSpawnTimer.start()
	playsound(dashSound)
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var audio_player: AudioStreamPlayer2D

func _ready():
	audio_player = $PlayerSounds
	
func _physics_process(delta):
	if GlobalVariables.PLAYER_CONTROLS_ENABLED:
		var direction = Input.get_axis("ui_left", "ui_right")
		#Handle dash
		if Input.is_action_just_pressed("Dash") and can_dash:
			if direction:
				dash()
				dashing = true
				# mozna tu wrzucic animacje dasha
				can_dash = false
				ghost_timer.start()
				$dash_again_timer.start()
			elif  Input.is_action_pressed("Jump"):
				dash()
				dashing = true
				can_dash = false
				ghost_timer.start()
				$dash_again_timer.start()
				velocity.y = DASH_UP
				velocity.x = 0
		#Crouch
		if Input.is_action_pressed("Crouch") and is_on_floor():
			
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
		if not is_on_floor():
			velocity.y += gravity * delta



		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		var dir = get_node("AnimatedSprite2D").flip_h
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction == 1 :
			get_node("AnimatedSprite2D").flip_h = false
			# Handle jump.

		update_animations(direction,dir)
		move_and_slide()
	else:
		anim.play("Idle")
	
	
func above_head_is_empty() -> bool:
	var result = !crouch_raycast1.is_colliding() and !crouch_raycast2.is_colliding()
	return result
	
func update_animations(direction,dir):
	if Input.is_action_just_pressed("Jump") and is_on_floor() and (!is_crouching and above_head_is_empty()) :
		velocity.y = JUMP_VELOCITY
		if anim.current_animation != "Attack"and anim.current_animation != "attack_left":
			anim.play("Jump")

		
	if Input.is_action_just_pressed("Attack"):
		if is_crouching == false:
			if(dir == false) :
				anim.play("Attack")
			else:
				anim.play("attack_left")
	if direction:
		if dashing:
			velocity.y = 0
			velocity.x = direction * DASH_SPEED
		else:
			if is_crouching:
				velocity.x = direction * SPEED*0.5
			else:
				velocity.x = direction * SPEED
			if( velocity.y == 0) and anim.current_animation != "Attack"  and anim.current_animation != "attack_left":
				if(is_crouching):
					anim.play("Crouch_walk")
				else :
					anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if( velocity.y== 0) and anim.current_animation != "Attack" and anim.current_animation != "attack_left":
			if is_crouching:
				anim.play("Crouch")
			else : 
				anim.play("Idle")
	if(velocity.y > 0) and anim.current_animation != "Attack" and anim.current_animation != "attack_left":
		anim.play("Fall")
func is_anim_playing() -> bool:
	if (anim.current_animation == "Attack" || anim.current_animation == "attack_left"):
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
	is_crouching = false;	
	cshape.shape = standing_cshape
	cshape.position.y = -1
func _on_weapon_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		print("Hit enemy")
		playsound(katanaSlashMetal)
		body.queue_free()
	pass 

func playsound(sound):
	audio_player.stream = sound
	audio_player.play()


func _on_ghost_timer_timeout():
	dashing = false
	particles.emitting = false

func _on_dash_again_timer_timeout():
	can_dash = true


func _on_ghost_spawn_timer_timeout():
	if dashing:
		add_ghost()
