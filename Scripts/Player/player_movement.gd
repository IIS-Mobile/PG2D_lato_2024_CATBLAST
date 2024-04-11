extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

@onready var katanaSweep: AudioStream = load("res://Assets/Sounds/player/katana sweep - Samuel Manzanero Recio.wav")
@onready var katanaSlashMetal: AudioStream = load("res://Assets/Sounds/player/slash against metal - mixkit.wav")
@onready var footsteps: AudioStream = load("res://Assets/Sounds/player/footstep - Pixabay.wav")
@onready var jump: AudioStream = load("res://Assets/Sounds/player/jump - Soundsnap and Friends.wav")
@onready var anim = get_node("AnimationPlayer")


@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer

func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position,$AnimatedSprite2D.scale)
	get_tree().current_scene.add_child(ghost)

	
func dash():
	ghost_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position+velocity * 1.5,0.45)
	await tween.finished
	ghost_timer.stop()
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var audio_player: AudioStreamPlayer2D

func _ready():
	audio_player = $AudioStreamPlayer2D
	
func _physics_process(delta):
	if Input.is_action_pressed("dash"):
		dash()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() :
		
		velocity.y = JUMP_VELOCITY
		if anim.current_animation != "Attack"and anim.current_animation != "attack_left":
			anim.play("Jump")
			playsound(jump)

		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	var dir = get_node("AnimatedSprite2D").flip_h
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1 :
		get_node("AnimatedSprite2D").flip_h = false
	if Input.is_action_just_pressed("Attack"):
		playsound(katanaSweep)
		if(dir == false) :
			anim.play("Attack")
		else:
			anim.play("attack_left")
	if direction:
		velocity.x = direction * SPEED
		if( velocity.y == 0) and anim.current_animation != "Attack"  and anim.current_animation != "attack_left":
			anim.play("Run")
			if $Timer.time_left <= 0:
				playsound(footsteps)
				$Timer.start(0.34)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if( velocity.y== 0) and anim.current_animation != "Attack"and anim.current_animation != "attack_left":
			anim.play("Idle")
	if(velocity.y > 0) and anim.current_animation != "Attack"and anim.current_animation != "attack_left":
		anim.play("Fall")
	move_and_slide()


func _on_weapon_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		print("Hit enemy")
		playsound(katanaSlashMetal)
		body.queue_free()
	pass # Replace with function body.

func playsound(sound):
	var random_index = randi() % 3
	var options = [0.9, 1.0, 1.1]
	audio_player.pitch_scale = options[random_index]
	audio_player.stream = sound
	audio_player.play()


func _on_ghost_timer_timeout():
	add_ghost()
