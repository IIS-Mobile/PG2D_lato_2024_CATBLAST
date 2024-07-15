extends Area2D



func _ready():
	pass # Replace with function body.



func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.is_climbing == false:
			body.is_climbing = true



func _on_body_exited(body):
		if body.is_in_group("player"):
			if body.is_climbing == true:
				body.is_climbing = false

