extends CharacterBody2D

const SPEED = 500.0
const LASER_MAX_SIZE = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player = null
var direction = null

@onready var timer = $Timer

func _ready():
	player = get_node("/root/GameManager/Player")
	direction = (player.global_position - global_position).normalized()
	rotation = direction.angle()
	scale.x = 0

	timer = Timer.new()
	timer.wait_time = 10.0
	timer.one_shot = true
	var callable = Callable(self, "_on_Timer_timeout")
	timer.connect("timeout", callable)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	if scale.x < LASER_MAX_SIZE:
		scale.x += 0.1
	move_and_slide()

func _on_Timer_timeout():
	queue_free()

func _on_hitbox_body_entered(body:Node2D):
	if body.name == "WorldTiles":
		queue_free()
