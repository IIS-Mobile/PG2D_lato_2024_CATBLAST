extends Control

# Declare volume levels
var master_volume = -20
var music_volume = -20
var sound_volume = -20

# References to the sliders
@onready var master_scrollbar = $MasterScrollbar
@onready var music_scrollbar = $MusicScrollbar
@onready var sound_scrollbar = $SoundScrollbar
@onready var chromatic_aberration_checkbox = $ChromaticAberrationCheckbox

func _ready() -> void:
	load_volume_settings()
	apply_volume_settings()
	update_slider_positions()

func _process(delta):
	pass

func _on_quit_pressed():
	hide()

func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)

func _on_master_scrollbar_value_changed(value):
	master_volume = value
	AudioServer.set_bus_volume_db(SoundtrackPlayer.master_bus, value)
	save_volume_settings()

	if value == -36:
		AudioServer.set_bus_mute(SoundtrackPlayer.master_bus, true)
	else:
		AudioServer.set_bus_mute(SoundtrackPlayer.master_bus, false)

func _on_music_scrollbar_value_changed(value):
	music_volume = value
	AudioServer.set_bus_volume_db(SoundtrackPlayer.music_bus, value)
	save_volume_settings()

	if value == -36:
		AudioServer.set_bus_mute(SoundtrackPlayer.music_bus, true)
	else:
		AudioServer.set_bus_mute(SoundtrackPlayer.music_bus, false)

func _on_sound_scrollbar_value_changed(value):
	sound_volume = value
	AudioServer.set_bus_volume_db(SoundEffectPlayer.sfx_bus, value)
	save_volume_settings()

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

func save_volume_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.set_value("graphics", "chromatic_aberration", GlobalVariables.CHROMATIC_ABERRATION)
	config.save("user://settings.cfg")

func load_volume_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		master_volume = config.get_value("audio", "master_volume", -20)
		music_volume = config.get_value("audio", "music_volume", -20)
		sound_volume = config.get_value("audio", "sound_volume", -20)
		chromatic_aberration_checkbox.button_pressed = config.get_value("graphics", "chromatic_aberration", true)
		GlobalVariables.CHROMATIC_ABERRATION = chromatic_aberration_checkbox.button_pressed

func apply_volume_settings():
	AudioServer.set_bus_volume_db(SoundtrackPlayer.master_bus, master_volume)
	AudioServer.set_bus_volume_db(SoundtrackPlayer.music_bus, music_volume)
	AudioServer.set_bus_volume_db(SoundEffectPlayer.sfx_bus, sound_volume)

	AudioServer.set_bus_mute(SoundtrackPlayer.master_bus, master_volume == -36)
	AudioServer.set_bus_mute(SoundtrackPlayer.music_bus, music_volume == -36)
	AudioServer.set_bus_mute(SoundEffectPlayer.sfx_bus, sound_volume == -36)

func update_slider_positions():
	master_scrollbar.value = master_volume
	music_scrollbar.value = music_volume
	sound_scrollbar.value = sound_volume

func _on_chromatic_aberration_checkbox_toggled(button_pressed: bool) -> void:
	GlobalVariables.CHROMATIC_ABERRATION = button_pressed
