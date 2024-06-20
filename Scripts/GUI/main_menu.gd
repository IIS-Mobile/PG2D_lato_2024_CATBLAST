extends Control


func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.MENU)


func _process(delta):
	pass


func _on_play_button_pressed():
	print("WCISŁEM")
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_credits_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	pass # Replace with function body.


func _on_play_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_options_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_credits_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_button_pressed():
	print("sraczka")
