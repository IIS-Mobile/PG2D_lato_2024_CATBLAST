extends CharacterBody2D

const SPEED = 60.0

@onready var player = get_node("/root/GameManager/Player")

var bullet = preload("res://Scenes/Enemies/bullet.tscn")

@onready var animation_tree : AnimationTree = $AnimationTree

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
	get_node("AnimatedSprite2D/AnimationPlayer").play("shoot")
