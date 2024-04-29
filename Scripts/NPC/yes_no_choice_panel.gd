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
	print("IT IS AN OPPORTUNITY TO SWTICH BETWEEN LEVELS BY TALKING TO NPC")
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true


func _on_no_button_pressed():
	print("NO...")
	choice_box.hide()
	GlobalVariables.PLAYER_CONTROLS_ENABLED = true
