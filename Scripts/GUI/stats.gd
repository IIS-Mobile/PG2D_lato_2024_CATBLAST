extends TextureRect

@export var slot_type: int = 0
@export var item_name: String
@onready var property: Dictionary = {"TEXTURE": texture,
									 "SLOT_TYPE": slot_type,
									 "ITEM_NAME": item_name}:
	set(value):
		property = value
		texture = property["TEXTURE"]
		slot_type = property["SLOT_TYPE"]
		item_name = property["ITEM_NAME"]
