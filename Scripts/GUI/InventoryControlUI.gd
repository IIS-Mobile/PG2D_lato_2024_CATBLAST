extends Control

@onready var inventory_controller = $"."

@onready var inventory_grid = $Inventory
var is_inventory_open = false

func _ready():
	GlobalVariables.item_pickup_signal.connect(add_item)

func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#if is_inventory_open:
			#inventory_controller.hide()
		#else:
			#inventory_controller.show()
		#is_inventory_open = !is_inventory_open
	pass


func add_item(item_name):
	var desired_implant
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == item_name:
			desired_implant = implant
			break
			
	var item_texture = load(desired_implant.graphic_path)
	var item_slot_type = desired_implant.slot_type
	var item_data = {"TEXTURE": item_texture,
					 "SLOT_TYPE": item_slot_type}
	
	desired_implant.posessed = true
	
	var index = 0
	
	var children_array = inventory_grid.get_children()
	
	for i in children_array:
		print("in loop")
		if i.filled == false:
			index = i.get_index()
			break
	print("after loop")
	inventory_grid.get_child(index).set_property(item_data)
