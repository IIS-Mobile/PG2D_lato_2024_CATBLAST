extends Node2D

@onready var menuMusic: AudioStream = load("res://Assets/Sounds/music/main menu theme - GreenStarFire.ogg")
@onready var confirmSound: AudioStream = load("res://Assets/Sounds/ui/button yes - phoenix_the_maker.wav")
@onready var hoverSound: AudioStream = load("res://Assets/Sounds/ui/hover button - Pixabay.wav")
@onready var pause_menu  =$"."

var audio_player: AudioStreamPlayer2D
var music_player: AudioStreamPlayer
var paused = false;

func _ready():
	audio_player = $AudioStreamPlayer2D
	music_player = $AudioStreamPlayer
	music_player.stream = menuMusic
	music_player.play()
	$Panel/Control/Play.grab_focus()
func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	$AudioStreamPlayer.stop()
	audio_player.stream = confirmSound
	audio_player.play()
	
	get_tree().change_scene_to_file("res://Scenes/TestLevel.tscn")
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to_file("res://Scenes/TestLevel.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		
		pauseMenu()
func pauseMenu():
	print("esc")
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

func _on_hover():
	audio_player.stream = hoverSound
	audio_player.play()

