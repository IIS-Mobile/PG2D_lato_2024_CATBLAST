extends TileMap

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var is_in_train_area: bool = true

func _process(delta):
	if GlobalVariables.TRAIN_SPEED != 0:
		if is_in_train_area:
			player.position.x += GlobalVariables.TRAIN_SPEED * delta		
		position.x += GlobalVariables.TRAIN_SPEED * delta

func _on_train_area_body_entered(body):
	if body.is_in_group("player"):
		is_in_train_area = true


func _on_train_area_body_exited(body):
	if body.is_in_group("player"):
		is_in_train_area = false
