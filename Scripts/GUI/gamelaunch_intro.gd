extends Node2D


func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.INTRO)
	$AnimationPlayer.play("Fade_in")
	await get_tree().create_timer(6).timeout
	$AnimationPlayer.play("Fade_out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
