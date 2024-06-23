extends Control

#func _ready() -> void:
	#AudioServer.set_bus_volume_db(SoundtrackPlayer.master_bus, -20)


func _process(delta):
	pass


func _on_quit_pressed():
	hide()


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)

func _on_master_scrollbar_value_changed(value):
	AudioServer.set_bus_volume_db(SoundtrackPlayer.master_bus, value)
	
	if value == -36:
		AudioServer.set_bus_mute(SoundtrackPlayer.master_bus, true)
	else:
		AudioServer.set_bus_mute(SoundtrackPlayer.master_bus, false)

func _on_music_scrollbar_value_changed(value):
	AudioServer.set_bus_volume_db(SoundtrackPlayer.music_bus, value)
	
	if value == -36:
		AudioServer.set_bus_mute(SoundtrackPlayer.music_bus, true)
	else:
		AudioServer.set_bus_mute(SoundtrackPlayer.music_bus, false)

func _on_sound_scrollbar_value_changed(value):
	AudioServer.set_bus_volume_db(SoundEffectPlayer.sfx_bus, value)
	
	if value == -36:
		AudioServer.set_bus_mute(SoundEffectPlayer.sfx_bus, true)
	else:
		AudioServer.set_bus_mute(SoundEffectPlayer.sfx_bus, false)



func _on_master_scrollbar_mouse_exited():
	pass
func _on_music_scrollbar_mouse_exited():
	pass
func _on_sound_scrollbar_mouse_exited():
	pass
