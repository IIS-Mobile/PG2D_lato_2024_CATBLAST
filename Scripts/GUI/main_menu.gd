extends Control


#var scene_preload
var CURRENT_HEALTH = 0
var LEVEL_TO_CHANGE = 0
var save_path = "user://variable.save"
var loaded_data = false

func load_data():
	print("x")
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var CURRENT_HEALTH = file.get_var()
			var LEVEL_TO_CHANGE = file.get_var()
			print("Loaded Health:", CURRENT_HEALTH)
			print("Loaded Level:", LEVEL_TO_CHANGE)
			
			for implant in GlobalVariables.IMPLANTS:
				var implant_val = file.get_var()
				print("Loaded Implant Value:", implant_val)
				if implant_val == 1:
					GlobalVariables.item_pickup_signal.emit(implant.name)
			file.close()
			GlobalVariables.CURRENT_HEALTH = CURRENT_HEALTH
			GlobalVariables.LEVEL_TO_CHANGE = LEVEL_TO_CHANGE
			loaded_data = true
			print("Data loaded successfully.")
		else:
			print("Failed to open file for reading")
	else:
		print("Save file does not exist")

func _ready():
	$SettingsMenu.hide()
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.MENU)
	if FileAccess.file_exists(save_path):
		print("Save found")
		$ContinueButton.disabled = false
	else:
		print("No save found")
		$ContinueButton.disabled = true
	#scene_preload = preload("res://Scenes/main.tscn").instantiate()


func _process(delta):
	pass


func _on_play_button_pressed():
	GlobalVariables.CURRENT_HEALTH = GlobalVariables.MAX_HEALTH
	GlobalVariables.LEVEL_TO_CHANGE = 1
	# remove impants
	for implant in GlobalVariables.IMPLANTS: # idk if this is the right way to do this
		implant.posessed = false			 # TODO: please check this
		implant.equipped = false			 # or even better, make start of new game in another way
											 # however, there is still an issue when level is reloaded upon death
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().change_scene_to_file("res://Scenes/prologue_section.tscn")
	#get_node("/root/MainMenu").queue_free()
	#get_tree().root.add_child(scene_preload)

func _on_continue_button_pressed():
	load_data()
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().change_scene_to_file("res://Scenes/prologue_section.tscn")
	#get_node("/root/MainMenu").queue_free()
	#get_tree().root.add_child(scene_preload)


func _on_options_button_pressed():
	$SettingsMenu.show()


func _on_credits_pressed():
	$PlayButton.hide()
	$ContinueButton.hide()
	$OptionsButton.hide()
	$Credits.hide()
	$Quit.hide()
	$CreditsTab.show()


func _on_quit_pressed():

	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().quit()


func _on_play_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)

func _on_continue_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_options_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_credits_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_credits_tab_tab_closed():
	$PlayButton.show()
	$ContinueButton.show()
	$OptionsButton.show()
	$Credits.show()
	$Quit.show()
