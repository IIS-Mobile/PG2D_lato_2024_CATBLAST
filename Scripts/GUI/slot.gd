extends PanelContainer
class_name Slot

@onready var texture_rect = $TextureRect

@export_enum("NONE:0", "ARMS:1", "BODY:2", "LEGS:3") var slot_type : int

var filled: bool = false

func _get_drag_data(at_position):
	set_drag_preview(get_preview())
	return texture_rect
	
func _can_drop_data(at_position, data):
	var retbool = true
	var desimp
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == data.property["ITEM_NAME"]:
			desimp = implant
	
	if desimp != null:
		if desimp.equipped:
			if data.slot_type == texture_rect.slot_type or texture_rect.slot_type == 0:
				retbool = true
			else:
				retbool = false
	else:
		retbool = false
	
	return data is TextureRect and retbool and !GlobalVariables.INVENTORY_LOOKUP_FLAG
	#return (data is TextureRect 
	#and (data.slot_type == texture_rect.slot_type 
	#or texture_rect.slot_type == 0))
	
func _drop_data(at_position, data):
	var temp = texture_rect.property
	texture_rect.property = data.property
	data.property = temp
	
	var old_property = texture_rect.property
	var new_property = data.property
	
	if old_property["ITEM_NAME"] == "" and new_property["ITEM_NAME"] != "":
		_on_item_equipped(new_property)
		
	elif old_property["ITEM_NAME"] != "" and new_property["ITEM_NAME"] == "":
		_on_item_unequipped(old_property)
		
	elif old_property["ITEM_NAME"] != "" and new_property["ITEM_NAME"] != "":
		if old_property["ITEM_NAME"] != new_property["ITEM_NAME"]:
			var imp1
			var imp2
			
			for implant in GlobalVariables.IMPLANTS:
				if implant.name == old_property["ITEM_NAME"]:
					imp1 = implant
					
			for implant in GlobalVariables.IMPLANTS:
				if implant.name == old_property["ITEM_NAME"]:
					imp2 = implant
					
			if imp1.equipped or imp2.equipped:
				_on_item_unequipped(old_property)
				_on_item_equipped(new_property)

func get_preview():
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(60, 60)
	preview_texture.z_index = 2137
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview

func set_property(item_data):
	texture_rect.property = item_data
	
	if item_data["TEXTURE"] == null:
		filled = false
	else:
		filled = true
		
func _on_item_equipped(item_data):
	print("Item equipped: ", item_data)

	for implant in GlobalVariables.IMPLANTS:
		if implant.name == item_data["ITEM_NAME"]:
			implant.equipped = true
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.ITEM_EQUIP)
	

func _on_item_unequipped(item_data):
	print("Item unequipped: ", item_data)
	for implant in GlobalVariables.IMPLANTS:
		if implant.name == item_data["ITEM_NAME"]:
			implant.equipped = false
	
