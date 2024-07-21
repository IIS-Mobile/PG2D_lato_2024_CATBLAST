extends Control

@export var game_manager: GameManager

var load_menu_scene
# Called when the node enters the scene tree for the first time.
var save_path = "user://variable.save"
var loaded_data = false


func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(GlobalVariables.CURRENT_HEALTH)
		#print(GlobalVariables.LEVEL_TO_CHANGE)
		file.store_var(GlobalVariables.LEVEL_TO_CHANGE)
		for implant in GlobalVariables.IMPLANTS:
			var implant_val = implant.posessed
			print(implant_val)
			if implant_val:
				file.store_var(1)
			else:
				file.store_var(0)
		file.close()
		print("Data saved successfully.")
	else:
		print("Failed to open file for writing")

	
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
		$SettingsMenu.hide()


func _on_resume_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	GlobalVariables.GAME_PAUSED = false
	$SettingsMenu.hide()
	print("res")
	
func _on_options_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)	
	$SettingsMenu.show()

func _on_quit_pressed():
	save()
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	GlobalVariables.GAME_PAUSED = false
	$SettingsMenu.hide()

	# get_parent().get_parent().get_parent().add_child(load_menu_scene)
	# get_parent().get_parent().queue_free()
	GlobalVariables.CURRENT_LEVEL = -1
	GlobalVariables.LEVEL_TO_CHANGE = 1
	

func _on_resume_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_options_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
