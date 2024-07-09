extends Node2D
class_name SOUNDTRACKPLAYER_CLASS

enum THEMES { PEACE, BATTLE }

var TRACKS = {
	THEMES.PEACE: [preload("res://Assets/Sounds/music/predator and prey - Yurika.ogg")],
	THEMES.BATTLE:
	[
		preload("res://Assets/Sounds/music/levelmusic - drmseq.ogg"),
		preload("res://Assets/Sounds/music/levelmusic2 - Pixabay.ogg"),
		preload("res://Assets/Sounds/music/safe - Alec Koff.ogg")
	]
}

var current_theme: int = THEMES.PEACE
var is_repeating: bool = true
var volume_delta = 20
@onready var streamPlayer: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	streamPlayer.volume_db -= volume_delta


func play_soundtrack(theme: int, repeat_themes: bool = true):
	if current_theme != theme or !streamPlayer.playing:
		is_repeating = false

		streamPlayer.stop()

		is_repeating = repeat_themes
		current_theme = theme

		var theme_tracks: Array = TRACKS[current_theme]
		if theme_tracks != []:
			streamPlayer.stream = theme_tracks[randi() % theme_tracks.size()]
			streamPlayer.play()


func replay_theme():
	var theme_tracks: Array = TRACKS[current_theme]
	streamPlayer.stream = theme_tracks[randi() % theme_tracks.size()]
	streamPlayer.play()


func _on_audio_stream_player_finished():
	if is_repeating:
		replay_theme()
