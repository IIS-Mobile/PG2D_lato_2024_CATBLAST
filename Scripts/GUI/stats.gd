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
	item_name = self.property["ITEM_NAME"]
	if item_name != "":
		var slot : int = self.property["SLOT_TYPE"]
		var slot_type : String
		if slot == 1:
			slot_type = "Arms"
		elif slot == 2:
			slot_type = "Body"
		elif slot == 3:
			slot_type = "Legs"
		var label_text : String = item_name + "\n"
		label_text += "Slot: " + slot_type + "\n\n"
		label_text += GlobalVariables.IMPLANTS_DESCRIPTIONS[get_implant_id(item_name)] + "\n"
		label.text = label_text
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.ITEM_HOVER)
		$ItemDescription.show()


func _on_mouse_exited():
	$ItemDescription.hide()
	
func get_implant_id(name: String):
	match name:
		"Full Precision Mechanical Arms":
			return 0
		"Carbon Fiber Arm Muscles":
			return 1
		"Circulatory System Enhancement":
			return 2
		"Ribcage Energy Shield":
			return 3
		"Ultra Elastic Joints":
			return 4
		"Light Titanium Leg Bones":
			return 5

