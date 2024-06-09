extends PanelContainer
class_name Slot

@onready var texture_rect = $TextureRect

@export_enum("NONE:0", "ARMS:1", "BODY:2", "LEGS:3") var slot_type : int

var filled: bool = false

func _get_drag_data(at_position):
	set_drag_preview(get_preview())
	return texture_rect
	
func _can_drop_data(at_position, data):
	return data is TextureRect
	
func _drop_data(at_position, data):
	var temp = texture_rect.property
	texture_rect.property = data.property
	data.property = temp

func get_preview():
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(60, 60)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview

func set_property(item_data):
	texture_rect.property = item_data
	
	if item_data["TEXTURE"] == null:
		filled = false
	else:
		filled = true
	
