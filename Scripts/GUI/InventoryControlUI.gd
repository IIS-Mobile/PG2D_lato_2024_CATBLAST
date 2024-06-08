extends Control

@onready var inventory_controller = $"."

var is_inventory_open = false
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if is_inventory_open:
			inventory_controller.hide()
		else:
			inventory_controller.show()
		is_inventory_open = !is_inventory_open
		
