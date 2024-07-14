extends Control

@export var game_manager: GameManager

var load_menu_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$SettingsMenu.hide()
	$Panel.get_node("Control/ResumeButton/AnimatedSprite2D").play("Glitch")
	$Panel.get_node("Control/OptionsButton/AnimatedSprite2D2").play("Glitch")
	$Panel.get_node("Control/Quit/AnimatedSprite2D3").play("Glitch")
	GlobalVariables.toggle_game_paused_signal.connect(_on_game_manager_toggle_game_paused)
	load_menu_scene = preload("res://Scenes/UI/main_menu.tscn").instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_manager_toggle_game_paused(is_paused: bool):
	if is_paused:
		show()
	else:
		hide()


func _on_resume_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	GlobalVariables.GAME_PAUSED = false
	print("res")
	
func _on_options_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)	
	$SettingsMenu.show()

func _on_quit_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	GlobalVariables.GAME_PAUSED = false

	# get_parent().get_parent().get_parent().add_child(load_menu_scene)
	# get_parent().get_parent().queue_free()
	GlobalVariables.CURRENT_LEVEL = -1
	GlobalVariables.LEVEL_TO_CHANGE = 0
	

func _on_resume_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_options_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
