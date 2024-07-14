extends ParallaxLayer

var train

func _ready():
	train = get_parent().get_parent()
func _process(delta):
	motion_offset.x = -train.position.x * 0.5




func _on_train_area_body_exited(body):
	pass # Replace with function body.
