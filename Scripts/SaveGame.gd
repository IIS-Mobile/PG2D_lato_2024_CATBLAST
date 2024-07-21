extends Node


var CURRENT_HEALTH = 0
var CURRENT_LEVEL = 0
var save_path = "user://variable.save"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func save():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(CURRENT_HEALTH)
	file.store_var(CURRENT_LEVEL)
func load_data():
	if(FileAccess.file_exists(save_path)):
		var file = FileAccess.open(save_path,FileAccess.READ)
		CURRENT_HEALTH = file.get_var(CURRENT_HEALTH)
		CURRENT_LEVEL = file.get_var(CURRENT_LEVEL)
	else:
		print("No save found")
		CURRENT_HEALTH = 0
		CURRENT_LEVEL = 0
