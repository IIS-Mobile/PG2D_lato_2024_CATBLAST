extends Control

@onready var choice_box = $ChoiceboxContainer


func _ready():
	choice_box.hide()


func _process(delta):
	pass


func window_summon():
	choice_box.show()

func _on_lobby_button_pressed():
	GlobalVariables.LEVEL_TO_CHANGE = 0
		
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false

func _on_level_1_button_pressed():
	#get_tree().change_scene_to_file(TestLevel2)
	GlobalVariables.LEVEL_TO_CHANGE = 1
		
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false


func _on_level_2_button_pressed():
	GlobalVariables.LEVEL_TO_CHANGE = 2
	
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false


func _on_pathfinding_button_pressed():
	GlobalVariables.LEVEL_TO_CHANGE = 3
	
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false

func _on_test_level_button_pressed():
	GlobalVariables.LEVEL_TO_CHANGE = 4
	
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false

func _on_cancel_button_pressed():
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
	GlobalVariables.IS_PLAYER_TALKING = false
