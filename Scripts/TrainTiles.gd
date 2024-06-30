extends TileMap

@onready var player = get_parent().get_parent().get_parent().get_node("Player")
@onready var is_in_train_area: bool = true

func _process(delta):
	if GlobalVariables.TRAIN_SPEED != 0:
		if (player.is_on_floor() || GlobalVariables.IS_PLAYER_CLIMBING) && is_in_train_area:
			player.position.x += GlobalVariables.TRAIN_SPEED * delta
			
		
		
		position.x += GlobalVariables.TRAIN_SPEED * delta


func _on_train_area_area_exited(area):
	print("POWSZEEEeeeeeeeeEDL")
	is_in_train_area =  false

func _on_train_area_area_entered(area):
	print("WSZEEeeeeeeeeEEDL")
	is_in_train_area =  true
