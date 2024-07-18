extends Node2D

var HAS_TALKED_WITH_CAPIBO_FIRST_TIME = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.BATTLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_first_call_from_capibo_body_entered(body):
	print("HALOOOO")
	print(body)
	if body.is_in_group("player"):
		if HAS_TALKED_WITH_CAPIBO_FIRST_TIME == false:
			print("powinno sie wykonac")
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.PHONECALL)
			await get_tree().create_timer(4).timeout
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/first_capibo_phonecall.txt")
			HAS_TALKED_WITH_CAPIBO_FIRST_TIME = true


func _on_first_call_from_capibo_body_exited(body):
	print("wyszlem????")
