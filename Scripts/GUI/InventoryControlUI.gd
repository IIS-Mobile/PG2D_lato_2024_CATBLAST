extends Control

@onready var inventory_controller = $"."

@onready var inventory_grid = $Inventory
@onready var passive_slots = $Character
var is_inventory_open = false

func _ready():
	GlobalVariables.item_pickup_signal.connect(add_item)
	GlobalVariables.item_equip_signal.connect(equip_item)
	GlobalVariables.open_implant_inventory.connect(open_inventory)
	inventory_controller.hide()

func open_inventory():
	inventory_controller.show()
	
func _on_done_button_pressed():
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.INVENTORY_CLOSE)
	inventory_controller.hide()

func add_item(item_name):
	var desired_implant
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == item_name:
			desired_implant = implant
			break
			
	var item_texture = load(desired_implant.graphic_path)
	var item_slot_type = desired_implant.slot_type
	
	var item_data = {"TEXTURE": item_texture,
					 "SLOT_TYPE": item_slot_type,
					 "ITEM_NAME": item_name}
	
	desired_implant.posessed = true
	
	var index = 0
	
	var children_array = inventory_grid.get_children()
	print(children_array)
	
	print(get_child_count())
	for i in children_array:
		if i.filled == false:
			index = i.get_index()
			print(i.get_index())
			break
	inventory_grid.get_child(index).set_property(item_data)

func equip_item(item_name):
	var desired_implant
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == item_name:
			desired_implant = implant
			break
			
	var item_texture = load(desired_implant.graphic_path)
	var item_slot_type = desired_implant.slot_type
	
	var item_data = {"TEXTURE": item_texture,
					 "SLOT_TYPE": item_slot_type,
					 "ITEM_NAME": item_name}
	desired_implant.equipped = true

	var index = 0
	var children_array = passive_slots.get_children()
	print(children_array)
	
	print(get_child_count())
	for i in children_array:
		if i.filled == false:
			index = i.get_index()
			print(i.get_index())
			break
	passive_slots.get_child(index).set_property(item_data)

func _on_done_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
