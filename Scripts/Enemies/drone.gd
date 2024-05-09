extends CharacterBody2D

const SPEED = 60.0

var player = null

var bullet = preload("res://Scenes/Enemies/bullet.tscn")

func _ready():
	player = get_node("/root/GameManager/Player")

func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	get_node("AnimatedSprite2D").flip_h = direction.x > 0
	velocity.x = direction.x * SPEED
	# velocity.y = direction.y * SPEED
	
	if randf() < 0.01:
		spawn_bullet()

	move_and_slide()


func spawn_bullet():
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	get_parent().add_child(bullet_instance)
	get_node("AnimationPlayer").play("shoot")
