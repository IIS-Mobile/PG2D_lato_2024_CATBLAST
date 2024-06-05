extends TextureRect

@export var slot_type: int = 0

@onready var property: Dictionary = {"TEXTURE": texture,
									 "SLOT_TYPE": slot_type}:
	set(value):
		property = value
		texture = property["TEXTURE"]
		slot_type = property["SLOT_TYPE"]
