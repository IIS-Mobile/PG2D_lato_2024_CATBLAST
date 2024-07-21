extends Control

var save_path = "user://variable.save"
var loaded_data = false



func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(GlobalVariables.CURRENT_HEALTH)
		file.store_var(GlobalVariables.LEVEL_TO_CHANGE)
		file.close()
		#print("Data saved" + CURRENT_LEVEL)
	else:
		print("Failed to open file for writing")
	
#var scene_preload
func _ready():
	$SettingsMenu.hide()
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.MENU)
	#scene_preload = preload("res://Scenes/main.tscn").instantiate()


func _process(delta):
	pass


func _on_play_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().change_scene_to_file("res://Scenes/prologue_section.tscn")
	#get_node("/root/MainMenu").queue_free()
	#get_tree().root.add_child(scene_preload)


func _on_options_button_pressed():
	$SettingsMenu.show()


func _on_credits_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	print(GlobalVariables.LEVEL_TO_CHANGE)
	save()
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().quit()


func _on_play_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_options_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_credits_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)

