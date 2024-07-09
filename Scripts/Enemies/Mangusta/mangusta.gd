extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const RANGE = 250.0

const COOLDOWN = 3.0 # seconds

@onready var player = get_node("/root/GameManager/Player")

@onready var bullet = preload("res://Scenes/Enemies/gun_bullet.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree

@onready var state_machine := $AnimationTree.get("parameters/playback") as AnimationNodeStateMachinePlayback

var timer = Timer.new()

var timer2 = Timer.new()

func _ready():
	timer = Timer.new()
	timer.set_wait_time(COOLDOWN)
	timer.set_one_shot(true)
	add_child(timer)
	timer2 = Timer.new()
	timer2.set_wait_time(0.5)
	timer2.set_one_shot(true)
	add_child(timer2)
	# var callable = Callable(self, "spawn_bullet")
	# timer2.connect("timeout", callable)
	animation_tree.active = true
	# animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


	

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if velocity.x > 0.0001:
		animation_tree.set("parameters/conditions/run", true)
		animation_tree.set("parameters/conditions/idle", false)
	else:
		animation_tree.set("parameters/conditions/run", false)
		animation_tree.set("parameters/conditions/idle", true)
	
	var direction = (player.global_position - global_position).normalized()
	
	# if current anim playing is shooting then velocity.x = 0
	if state_machine.get_current_node() == "shoot":
		velocity.x = 0

	velocity.x = direction.x * SPEED


	# velocity.y = direction.y * SPEED
	

	get_node("AnimatedSprite2D").flip_h = direction.x < 0

	# if player is in range
	if player.global_position.distance_to(global_position) < RANGE:
		# if timer is counting
		if timer.is_stopped():
			animation_tree.set("parameters/conditions/shoot", true)
			timer2.start()
			timer.start()

	move_and_slide()


func spawn_bullet():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	get_parent().add_child(bullet_instance)
	animation_tree.set("parameters/conditions/shoot", false)
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.GUN_SHOT)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "death":
		death()

func death():
	velocity.x = 0
	queue_free()