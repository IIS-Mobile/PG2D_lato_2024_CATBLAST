extends TileMap

var velocity = 0
var max_speed = 250
var acceleration = 50
var should_move = false

func _process(delta):
	if should_move:
		velocity += acceleration * delta
		velocity = min(velocity, max_speed)
		position.x += velocity * delta


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		should_move = true
		$Area2D.queue_free()
