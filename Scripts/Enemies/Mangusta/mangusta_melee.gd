extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var health = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const RANGE = 50.0

const COOLDOWN = 3.0 # seconds

@onready var player = get_node("/root/GameManager/Player")

@onready var bullet = preload("res://Scenes/Enemies/gun_bullet.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree

@onready var hitbox = $Hitbox

@onready var marker2D = $Marker2D

@onready var attack_collision_polygon : CollisionPolygon2D = $Marker2D/Hitbox/Attack

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

	if current_animation == "attack" or current_animation == "death" or current_animation == "End":
		velocity.x = 0
	else:
		velocity.x = direction.x * SPEED
		if direction.x > 0:
			marker2D.scale.x = 1
		elif direction.x < 0:
			marker2D.scale.x = -1
		
		get_node("AnimatedSprite2D").flip_h = direction.x < 0


	# velocity.y = direction.y * SPEED


	var distance = player.global_position.distance_to(global_position)
	# if player is in range
	if distance < RANGE and current_animation != "attack" and current_animation != "death" and current_animation != "End":
		# if timer is counting
		if timer.is_stopped():
			animation_tree.set("parameters/conditions/attack", true)
			attack()
			timer.start()

	move_and_slide()


func attack():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.KATANA_SWING)
	# ???

func take_damage(damage):
	health -= damage
	if health <= 0:
		killed()

func killed():
	animation_tree.set("parameters/conditions/death", true)
	velocity.x = 0

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "death":
		attack_collision_polygon.disabled = true
		velocity.x = 0
	elif anim_name == "attack":
		animation_tree.set("parameters/conditions/attack", false)
	

func _on_hitbox_body_entered(body:Node2D):
	if body.is_in_group("player"):
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SLASH_FLESH)
	
