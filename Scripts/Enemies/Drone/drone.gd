extends CharacterBody2D

const SPEED = 60.0

const FIRE_RANGE = 250.0

const VIEW_RANGE = 400.0

const COOLDOWN = 3.0 # seconds

const MAX_HEALTH = 1

var health = MAX_HEALTH

var is_triggered = false

@onready var start_position = global_position

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("/root/GameManager/Player")

@onready var laser = preload("res://Scenes/Enemies/laser.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree

var timer = Timer.new()

@onready var raycast : RayCast2D = $RayCast2D


func _ready():
	timer = Timer.new()
	timer.set_wait_time(COOLDOWN)
	timer.set_one_shot(true)
	add_child(timer)
	animation_tree.active = true

	

func _physics_process(delta):

	if GlobalVariables.IS_MILITIA_TRIGGERED == true:
		is_triggered = true

	if health < MAX_HEALTH:
		trigger()

	var direction = (player.global_position - global_position).normalized()
		
	animation_tree.set("parameters/conditions/idle", true)
	# check current anim playing, if shooting then stop moving
	var current_animation = animation_tree.get("parameters/playback").get_current_node()
	if current_animation == "charge" or current_animation == "shoot" or is_triggered == false:
		velocity.x = 0
		velocity.y = 0
	else:
		if player.global_position.distance_to(global_position) < VIEW_RANGE:
			raycast.target_position = (player.global_position - global_position).normalized() * player.global_position.distance_to(global_position)

			raycast.force_raycast_update()

			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider.name == "Player":
					velocity.x = direction.x * SPEED
					# velocity.y = direction.y * SPEED
					get_node("AnimatedSprite2D").flip_h = direction.x > 0


	if current_animation == "death" or current_animation == "End":
		velocity.x = 0
		set_collision_layer_value(1, false)
		velocity.y += gravity * delta
		

	# if player is in range
	if is_triggered and player.global_position.distance_to(global_position) < FIRE_RANGE:

		raycast.target_position = (player.global_position - global_position).normalized() * player.global_position.distance_to(global_position)

		raycast.force_raycast_update()

		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.name == "Player":
				velocity.x = 0
				# if timer is counting
				if timer.is_stopped():
					animation_tree.set("parameters/conditions/shoot", true)
					timer.start()


	move_and_slide()


func spawn_laser():
	var laser_instance = laser.instantiate()
	laser_instance.position = position
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
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.EXPLOSION)
	var area = $Hitbox
	var collisionShape = $Hitbox/ExplosionCollisionShape
	collisionShape.disabled = false
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.take_damage(1)


func trigger():
	is_triggered = true
	GlobalVariables.IS_MILITIA_TRIGGERED = true
