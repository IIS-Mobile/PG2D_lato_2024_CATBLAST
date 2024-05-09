extends CharacterBody2D

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player = null
var direction = null

func _ready():
	player = get_node("/root/GameManager/Player")
	direction = (player.global_position - global_position).normalized()

func _physics_process(delta):
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	move_and_slide()
