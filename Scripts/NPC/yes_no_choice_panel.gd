extends Control

@onready var choice_box = $ChoiceboxContainer


func _ready():
	choice_box.hide()


func _process(delta):
	pass


func window_summon():
	choice_box.show()


func _on_yes_button_pressed():
	#get_tree().change_scene_to_file(TestLevel2)
	if GlobalVariables.LEVEL_TO_CHANGE == 1:
		GlobalVariables.LEVEL_TO_CHANGE = 0;
	elif GlobalVariables.LEVEL_TO_CHANGE == 0:
		GlobalVariables.LEVEL_TO_CHANGE = 1;
		
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false


func _on_no_button_pressed():
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false
