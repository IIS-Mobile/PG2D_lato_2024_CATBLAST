extends CharacterBody2D

const SPEED = 60.0

const RANGE = 250.0

const COOLDOWN = 3.0 # seconds

var health = 1

@onready var start_position = global_position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("/root/GameManager/Player")

@onready var laser = preload("res://Scenes/Enemies/laser.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree

var timer = Timer.new()


func _ready():
	timer = Timer.new()
	timer.set_wait_time(COOLDOWN)
	timer.set_one_shot(true)
	add_child(timer)
	animation_tree.active = true

	

func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
		
	animation_tree.set("parameters/conditions/idle", true)
	# check current anim playing, if shooting then stop moving
	var current_animation = animation_tree.get("parameters/playback").get_current_node()
	if current_animation == "charge" or current_animation == "shoot":
		velocity.x = 0
		velocity.y = 0
	else:
		velocity.x = direction.x * SPEED
		# velocity.y = direction.y * SPEED
		get_node("AnimatedSprite2D").flip_h = direction.x > 0

	if current_animation == "death" or current_animation == "End":
		velocity.x = 0
		set_collision_layer_value(1, false)
		velocity.y += gravity * delta
		

	# if player is in range
	if player.global_position.distance_to(global_position) < RANGE:
		# if timer is counting
		if timer.is_stopped():
			animation_tree.set("parameters/conditions/shoot", true)
			timer.start()


	move_and_slide()


func spawn_laser():
	var laser_instance = laser.instantiate()
	laser_instance.global_position = global_position
	get_parent().add_child(laser_instance)
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.LASER_SHOT)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "charge":
		animation_tree.set("parameters/conditions/shoot", false)
	elif anim_name == "death":
		queue_free()

func take_damage(damage):
	health -= damage
	if health <= 0:
		animation_tree.set("parameters/conditions/death", true)
		velocity.x = 0
		velocity.y = 0

func explosion_damage():
	var area = $Hitbox
	var collisionShape = $Hitbox/ExplosionCollisionShape
	collisionShape.disabled = false
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.take_damage(1)
