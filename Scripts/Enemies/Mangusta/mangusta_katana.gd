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

var timer = Timer.new()

# var timer2 = Timer.new()

func _ready():
	timer = Timer.new()
	timer.set_wait_time(COOLDOWN)
	timer.set_one_shot(true)
	add_child(timer)
	# timer2 = Timer.new()
	# timer2.set_wait_time(0.5)
	# timer2.set_one_shot(true)
	# add_child(timer2)
	# # var callable = Callable(self, "spawn_bullet")
	# # timer2.connect("timeout", callable)
	animation_tree.active = true
	# animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


	

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

	# scale.x = -1

	# velocity.y = direction.y * SPEED
	


	var distance = player.global_position.distance_to(global_position)
	# if player is in range
	if distance < RANGE:
		# if timer is counting
		if timer.is_stopped():
			animation_tree.set("parameters/conditions/attack", true)
			attack()
			# timer2.start()
			timer.start()

	move_and_slide()


func attack():
	# todo
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SLASH_FLESH) # ???

func take_damage(damage):
	health -= damage
	if health <= 0:
		killed()

func killed():
	animation_tree.set("parameters/conditions/death", true)
	velocity.x = 0

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "death":
		velocity.x = 0
	elif anim_name == "attack":
		animation_tree.set("parameters/conditions/attack", false)
	
