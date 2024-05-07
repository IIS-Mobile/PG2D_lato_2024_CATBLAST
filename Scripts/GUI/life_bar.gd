extends Control

var hp_point_width: int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVariables.CURRENT_HEALTH > 0:
		$health_points.size.x = hp_point_width * GlobalVariables.CURRENT_HEALTH;
	else:
		$health_points.texture = null
	pass
