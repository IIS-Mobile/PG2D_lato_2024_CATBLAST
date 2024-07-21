extends Node2D

var skip_timers = false

func _ready():
	AudioServer.set_bus_volume_db(SoundtrackPlayer.master_bus, -6)
	AudioServer.set_bus_volume_db(SoundtrackPlayer.music_bus, -12)
	AudioServer.set_bus_volume_db(SoundEffectPlayer.sfx_bus, -6)
	
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.INTRO)
	$AnimationPlayer.play("Fade_in")
	await _wait_or_skip(6)
	if skip_timers:
		return
	$AnimationPlayer.play("Fade_out")
	await _wait_or_skip(3)
	if skip_timers:
		return
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _wait_or_skip(seconds):
	var timer = get_tree().create_timer(seconds)
	while not skip_timers and not timer.time_left == 0:
		await get_tree().process_frame
	if skip_timers:
		return


func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		skip_timers = true
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
