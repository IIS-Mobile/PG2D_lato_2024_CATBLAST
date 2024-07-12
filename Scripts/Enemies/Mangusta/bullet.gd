extends CharacterBody2D

const SPEED = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player = null
var direction = null

@onready var timer = $Timer

func _ready():
	player = get_node("/root/GameManager/Player")
	direction = (player.global_position - global_position).normalized()
	rotation = direction.angle()

	timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	var callable = Callable(self, "_on_Timer_timeout")
	timer.connect("timeout", callable)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	velocity.x = direction.x * SPEED
	velocity.y = direction.y * SPEED
	move_and_slide()

func _on_Timer_timeout():
	queue_free()

func _on_hitbox_body_entered(body:Node2D):
	# if body.is_in_group("player") or body is TileMap:
	if body.is_in_group("player"):
		queue_free()
	elif body.name == "WorldTiles":
		queue_free()



func _on_hitbox_area_entered(area:Area2D):
	if area.is_in_group("katana"):
		queue_free()
