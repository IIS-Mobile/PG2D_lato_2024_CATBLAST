extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func implant_picked(name_to_find: String):
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == name_to_find:
			implant.possessed = true
			print("zebrano ", name_to_find)
			return
	print("Implant with name", name_to_find, "not found.")
	
func implant_equipped(name_to_find: String):
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == name_to_find:
			implant.equipped = true
			print("zalozono ", name_to_find)
			return
	print("Implant with name ", name_to_find, " not found.")
