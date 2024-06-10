extends Slot
class_name PassiveSlot

func _can_drop_data(_pos, data):
	return data is TextureRect and data.slot_type == slot_type
	
	
func _drop_data(at_position, data):
	var old_property = texture_rect.property
	var new_property = data.property
	
	var temp = texture_rect.property
	texture_rect.property = data.property
	data.property = temp
	
	if old_property["ITEM_NAME"] == "" and new_property["ITEM_NAME"] != "":
		_on_item_equipped(new_property)
	elif old_property["ITEM_NAME"] != "" and new_property["ITEM_NAME"] == "":
		_on_item_unequipped(old_property)
	elif old_property["ITEM_NAME"] != "" and new_property["ITEM_NAME"] != "":
		_on_item_unequipped(old_property)
		_on_item_equipped(new_property)
