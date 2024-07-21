extends Node2D
class_name SOUNDTRACKPLAYER_CLASS

enum THEMES { PEACE, BATTLE, UNDERGROUND, MENU, INTRO, PROLOGUE }

var TRACKS = {
	THEMES.INTRO: [preload("res://Assets/Sounds/music/intro sound - moodmode.ogg")],
	THEMES.MENU: [preload("res://Assets/Sounds/music/main menu theme - GreenStarFire.ogg")],
	THEMES.PEACE: [preload("res://Assets/Sounds/music/predator and prey - Yurika.ogg")],
	THEMES.BATTLE:
	[
		preload("res://Assets/Sounds/music/levelmusic1 - Panda Beats.ogg"),
		preload("res://Assets/Sounds/music/levelmusic2 - Panda Beats.ogg"),
		preload("res://Assets/Sounds/music/levelmusic4 - Panda Beats.ogg"),
		preload("res://Assets/Sounds/music/levelmusic5 - Panda Beats.ogg"),
		preload("res://Assets/Sounds/music/levelmusic6 - Panda Beats.ogg"),
		preload("res://Assets/Sounds/music/safe - Alec Koff.ogg"),
	],
	THEMES.UNDERGROUND: [preload("res://Assets/Sounds/music/levelmusic3 underground - Panda Beats.ogg")],
	THEMES.PROLOGUE: [preload("res://Assets/Sounds/music/prologue music - Panda Beats.mp3")]
}

# Copy -> SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.BATTLE)

var current_theme: int = THEMES.PEACE
var is_repeating: bool = true

@export var master_bus_name := "Master"
@export var music_bus_name := "Music"

@onready var master_bus := AudioServer.get_bus_index(master_bus_name)
@onready var music_bus := AudioServer.get_bus_index(music_bus_name)

@onready var streamPlayer: AudioStreamPlayer = $AudioStreamPlayer

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
