extends TextureRect

@export var slot_type: int = 0
@export var item_name: String

@onready var label = $ItemDescription/MarginContainer/MarginContainer/Label
@onready var property: Dictionary = {"TEXTURE": texture,
									 "SLOT_TYPE": slot_type,
									 "ITEM_NAME": item_name}:
	set(value):
		property = value
		texture = property["TEXTURE"]
		slot_type = property["SLOT_TYPE"]
		item_name = property["ITEM_NAME"]

func _ready():
	$ItemDescription.hide()

func _on_mouse_entered():
	if self.property["ITEM_NAME"] != "":
		var slot : int = self.property["SLOT_TYPE"]
		var slot_type : String
		if slot == 1:
			slot_type = "Arms"
		elif slot == 2:
			slot_type = "Body"
		elif slot == 3:
			slot_type = "Legs"
		var label_text : String = self.property["ITEM_NAME"] + "\n"
		label_text += "Slot: " + slot_type + "\n"
		
		label.text = label_text
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
		$ItemDescription.show()


func _on_mouse_exited():
	$ItemDescription.hide()
