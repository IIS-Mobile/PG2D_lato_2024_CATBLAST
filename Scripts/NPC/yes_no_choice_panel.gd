extends Control

@onready var choice_box = $ChoiceboxContainer


func _ready():
	choice_box.hide()


func _process(delta):
	pass


func window_summon():
	choice_box.show()


func _on_yes_button_pressed():
	GlobalVariables.open_implant_inventory_signal.emit()
	GlobalVariables.IS_INVENTORY_OPEN = true
	choice_box.hide()

func _on_no_button_pressed():
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false
