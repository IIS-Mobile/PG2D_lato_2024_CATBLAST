extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var health = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const RANGE = 250.0

const COOLDOWN = 3.0 # seconds

@onready var player = get_node("/root/GameManager/Player")

@onready var bullet = preload("res://Scenes/Enemies/Bullet.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree

var timer = Timer.new()

func _ready():
	timer = Timer.new()
	timer.set_wait_time(COOLDOWN)
	timer.set_one_shot(true)
	add_child(timer)
	animation_tree.active = true


func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if abs(velocity.x) > 0.0001:
		animation_tree.set("parameters/conditions/run", true)
		animation_tree.set("parameters/conditions/idle", false)
	else:
		animation_tree.set("parameters/conditions/run", false)
		animation_tree.set("parameters/conditions/idle", true)
	
	var direction = (player.global_position - global_position).normalized()
	
	var current_animation = animation_tree.get("parameters/playback").get_current_node()
	# if current anim playing is shooting then velocity.x = 0
	if current_animation == "shoot" or current_animation == "death" or current_animation == "End":
		velocity.x = 0
	else:
		velocity.x = direction.x * SPEED
		get_node("AnimatedSprite2D").flip_h = direction.x < 0


	# velocity.y = direction.y * SPEED

	# if player is in range
	if player.global_position.distance_to(global_position) < RANGE:
		# if timer is counting
		if timer.is_stopped():
			animation_tree.set("parameters/conditions/shoot", true)
			timer.start()

	move_and_slide()


func spawn_bullet():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	get_parent().add_child(bullet_instance)
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.GUN_SHOT)

func take_damage(damage):
	health -= damage
	if health <= 0:
		animation_tree.set("parameters/conditions/death", true)
		velocity.x = 0
		velocity.y = 0

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "death":
		velocity.x = 0
	elif anim_name == "shoot":
		animation_tree.set("parameters/conditions/shoot", false)
	
