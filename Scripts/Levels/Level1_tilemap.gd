extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	set_layer_enabled (6, true)
	set_layer_enabled (5, false)




func _process(delta):
	pass

func change_after_ratface_death():
	set_layer_enabled (6, false)
	set_layer_enabled (5, true)


func _on_placeholde_ratface_death_body_entered(body):
	if body.is_in_group("player"):
		change_after_ratface_death()
