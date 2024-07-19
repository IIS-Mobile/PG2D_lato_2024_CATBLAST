extends Node2D

var HAS_TALKED_WITH_CAPIBO_FIRST_TIME = false
var HAS_GRABBED_THE_IMPLANT = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.BATTLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_first_call_from_capibo_body_entered(body):
	if body.is_in_group("player"):
		if HAS_TALKED_WITH_CAPIBO_FIRST_TIME == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.PHONECALL)
			await get_tree().create_timer(4).timeout
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/first_capibo_phonecall.txt")
			HAS_TALKED_WITH_CAPIBO_FIRST_TIME = true


func _on_first_call_from_capibo_body_exited(body):
	print("left first phonecall area")


func _on_grab_the_implant_reminder_body_entered(body):
	if body.is_in_group("player"):
		if HAS_GRABBED_THE_IMPLANT == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/grab_the_implant_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()
