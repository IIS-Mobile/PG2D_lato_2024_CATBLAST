extends Control

@onready var inventory_controller = $"."

@onready var inventory_grid = $Inventory
@onready var passive_slots = $Character

func _ready():
	GlobalVariables.item_pickup_signal.connect(add_item)
	GlobalVariables.item_equip_signal.connect(equip_item)
	GlobalVariables.open_implant_inventory_signal.connect(open_inventory)
	$LookupInfoLabel.hide()
	close_inventory()

func _process(delta):
	if Input.is_action_just_pressed("Inventory") and !GlobalVariables.IS_PLAYER_TALKING:
		if !GlobalVariables.INVENTORY_LOOKUP_FLAG and !GlobalVariables.IS_INVENTORY_OPEN:
			open_inventory()
			GlobalVariables.IS_INVENTORY_OPEN = true
			GlobalVariables.INVENTORY_LOOKUP_FLAG = true
			$LookupInfoLabel.show()
		elif GlobalVariables.INVENTORY_LOOKUP_FLAG or GlobalVariables.IS_INVENTORY_OPEN:
			inventory_closing_cleanup()
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.INVENTORY_CLOSE)
			close_inventory()

func open_inventory():
	inventory_controller.show()
	
func close_inventory():
	inventory_controller.hide()

func inventory_closing_cleanup():
	GlobalVariables.IS_INVENTORY_OPEN = false
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false
	GlobalVariables.INVENTORY_LOOKUP_FLAG = false
	$LookupInfoLabel.hide()

func _on_done_button_pressed():
	inventory_closing_cleanup()
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.INVENTORY_CLOSE)
	close_inventory()

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
