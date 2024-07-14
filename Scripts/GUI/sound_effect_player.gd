extends Node2D
class_name SFX_CLASS

const KATANA_SLASH_METAL_PATH = "res://Assets/Sounds/player/slash against metal - mixkit.wav"
const KATANA_SLASH_FLESH_PATH = "res://Assets/Sounds/player/slash against flesh - mixkit.wav"
const DASH_PATH = "res://Assets/Sounds/player/dash - danlew69.wav"
const CONFIRM_PATH = "res://Assets/Sounds/ui/button yes - phoenix_the_maker.wav"
const HOVER_PATH = "res://Assets/Sounds/ui/hover button - Pixabay.wav"
const LETTERS_POP_PATH = "res://Assets/Sounds/ui/dialogue letters sound effect - floraphonic.wav"
const HEAL_PATH = "res://Assets/Sounds/player/heal up - Pixabay.mp3"
const LASER_SHOT_PATH = "res://Assets/Sounds/enemies/laser shot - Pixabay.wav"
const GUN_SHOT_PATH = "res://Assets/Sounds/enemies/gun shot - pixabay.wav"
const ITEM_EQUIP_PATH = "res://Assets/Sounds/ui/item equip - Fronbondi_Skegs.wav"
const ITEM_PICKUP_PATH = "res://Assets/Sounds/ui/item pickup - Phil Michalski.wav"
const ITEM_HOVER_PATH = "res://Assets/Sounds/ui/item hover - Empty Sea Audio.wav"
const INVENTORY_CLOSE_PATH = "res://Assets/Sounds/ui/close implant inventory - Phil Michalski.wav"
const SHIELD_CHARGED_PATH = "res://Assets/Sounds/player/shield charged - Pixabay.wav"
const SHIELD_DISCHARGE_PATH = "res://Assets/Sounds/player/shield discharge new - Pixabay.wav"
const DOUBLE_JUMP_PATH = "res://Assets/Sounds/player/double jump - Soundmorph.wav"
const JUMP_PATH = "res://Assets/Sounds/player/jump - Soundsnap and Friends.wav"
const KATANA_SWING_PATH = "res://Assets/Sounds/player/katana sweep - Samuel Manzanero Recio.wav"
const EXPLOSION_PATH = "res://Assets/Sounds/enemies/explosion.wav"

enum SOUNDS { SLASH_METAL, SLASH_FLESH, DASH, CONFIRM, HOVER, LETTERS_POP, HEAL, LASER_SHOT, 
			GUN_SHOT, ITEM_EQUIP, ITEM_PICKUP, ITEM_HOVER, INVENTORY_CLOSE, SHIELD_CHARGED, SHIELD_DISCHARGE,
			DOUBLE_JUMP, JUMP, KATANA_SWING, EXPLOSION }

# Copy -> SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.SLASH_METAL)

var PLAYSOUND = {
	SOUNDS.SLASH_METAL: load(KATANA_SLASH_METAL_PATH),
	SOUNDS.SLASH_FLESH: load(KATANA_SLASH_FLESH_PATH),
	SOUNDS.DASH: load(DASH_PATH),
	SOUNDS.CONFIRM: load(CONFIRM_PATH),
	SOUNDS.HOVER: load(HOVER_PATH),
	SOUNDS.LETTERS_POP: load(LETTERS_POP_PATH),
	SOUNDS.HEAL: load(HEAL_PATH),
	SOUNDS.LASER_SHOT: load(LASER_SHOT_PATH),
	SOUNDS.GUN_SHOT: load(GUN_SHOT_PATH),
	SOUNDS.ITEM_EQUIP: load(ITEM_EQUIP_PATH),
	SOUNDS.ITEM_PICKUP: load(ITEM_PICKUP_PATH),
	SOUNDS.ITEM_HOVER: load(ITEM_HOVER_PATH),
	SOUNDS.INVENTORY_CLOSE: load(INVENTORY_CLOSE_PATH),
	SOUNDS.SHIELD_CHARGED: load(SHIELD_CHARGED_PATH),
	SOUNDS.SHIELD_DISCHARGE: load(SHIELD_DISCHARGE_PATH),
	SOUNDS.DOUBLE_JUMP: load(DOUBLE_JUMP_PATH),
	SOUNDS.JUMP: load(JUMP_PATH),
	SOUNDS.KATANA_SWING: load(KATANA_SWING_PATH),
	SOUNDS.EXPLOSION: load(EXPLOSION_PATH)
}

@onready var audio_player
@onready var players = []
var volume_delta = 20

var playersN = 16
var index

func _ready():
	index = 0
	for _i in range(playersN):
		var player : AudioStreamPlayer = AudioStreamPlayer.new()
		player.volume_db -= volume_delta
		players.append(player)
		add_child(player)

func get_player():
	var player : AudioStreamPlayer = players[index]
	index = (index + 1) % playersN
	return player

func playsound(sound):
	audio_player = get_player()
	audio_player.stream = PLAYSOUND[sound]
	audio_player.play()
