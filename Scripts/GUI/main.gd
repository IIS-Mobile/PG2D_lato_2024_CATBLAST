extends Node2D

class_name GameManager

signal toggle_game_paused(is_paused: bool)

@onready var pause_menu  =$"."

var audio_player: AudioStreamPlayer2D

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
	randomize()
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.PEACE)
#


func _on_hover():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
