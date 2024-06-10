extends Node2D
class_name SFX_CLASS
const KATANA_SLASH_PATH = "res://Assets/Sounds/player/slash against metal - mixkit.wav"
const DASH_PATH = "res://Assets/Sounds/player/dash - danlew69.wav"
const CONFIRM_PATH = "res://Assets/Sounds/ui/button yes - phoenix_the_maker.wav"
const HOVER_PATH = "res://Assets/Sounds/ui/hover button - Pixabay.wav"
const LETTERS_POP_PATH = "res://Assets/Sounds/ui/dialogue letters sound effect - floraphonic.wav"
const HEAL_PATH = "res://Assets/Sounds/player/heal up - Pixabay.mp3"
const LASER_SHOT_PATH = "res://Assets/Sounds/enemies/laser shot - Pixabay.wav"
const GUN_SHOT_PATH = "res://Assets/Sounds/enemies/gun shot - pixabay.wav"

enum SOUNDS { SLASH_METAL, DASH, CONFIRM, HOVER, LETTERS_POP, HEAL, LASER_SHOT, GUN_SHOT}

var PLAYSOUND = {
	SOUNDS.SLASH_METAL: load(KATANA_SLASH_PATH),
	SOUNDS.DASH: load(DASH_PATH),
	SOUNDS.CONFIRM: load(CONFIRM_PATH),
	SOUNDS.HOVER: load(HOVER_PATH),
	SOUNDS.LETTERS_POP: load(LETTERS_POP_PATH),
	SOUNDS.HEAL: load(HEAL_PATH),
	SOUNDS.LASER_SHOT: load(LASER_SHOT_PATH),
	SOUNDS.GUN_SHOT: load(GUN_SHOT_PATH)
}

@onready var audio_player = $AudioStreamPlayer
var volume_delta = 20


func _ready():
	audio_player.volume_db -= volume_delta


func playsound(sound):
	print(sound)
	audio_player.stream = PLAYSOUND[sound]
	audio_player.play()
