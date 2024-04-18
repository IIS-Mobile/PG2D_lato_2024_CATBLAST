extends Node2D

class_name GameManager

signal toggle_game_paused(is_paused: bool)

@onready var menuMusic: AudioStream = load("res://Assets/Sounds/music/main menu theme - GreenStarFire.ogg")
@onready var confirmSound: AudioStream = load("res://Assets/Sounds/ui/button yes - phoenix_the_maker.wav")
@onready var hoverSound: AudioStream = load("res://Assets/Sounds/ui/hover button - Pixabay.wav")
@onready var pause_menu  =$"."

var audio_player: AudioStreamPlayer2D
var music_player: AudioStreamPlayer

var game_paused : bool = false :
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused",game_paused)
	
func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused

func _ready():
	audio_player = $AudioStreamPlayer2D
	music_player = $AudioStreamPlayer
	music_player.stream = menuMusic
	music_player.play()
#
#func _on_play_pressed():
	#$AudioStreamPlayer.stop()
	#audio_player.stream = confirmSound
	#audio_player.play()
	#
	#get_tree().change_scene_to_file("res://Scenes/TestLevel.tscn")
#
#func pauseMenu():
	#var current_value : bool = get_tree().paused
	#get_tree().paused = !current_value
	#if get_tree().paused:
		#pause_menu.hide()
	#else:
		#pause_menu.show()

func _on_hover():
	audio_player.stream = hoverSound
	audio_player.play()

