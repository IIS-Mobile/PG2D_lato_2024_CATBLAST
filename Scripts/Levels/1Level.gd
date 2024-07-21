extends Node2D

var HAS_TALKED_WITH_CAPIBO_FIRST_TIME = false
var HAS_GRABBED_THE_IMPLANT = false
var HAS_KILLED_OLD_MAN = false
var has_entered_implant_chest = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.BATTLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (has_entered_implant_chest == true 
	and Input.is_action_just_pressed("Interact")
	and not GlobalVariables.IS_PLAYER_TALKING 
	and not GlobalVariables.IS_INVENTORY_OPEN):
		print("wow  podniosles wszczepa xdd")
		HAS_GRABBED_THE_IMPLANT = true
		


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


func _on_placeholder_implant_chest_body_entered(body):
	if body.is_in_group("player"):
		print("jestes w skrzyni")
		has_entered_implant_chest = true


func _on_placeholder_implant_chest_body_exited(body):
	if body.is_in_group("player"):
		print("opusciles skrzynie")
		has_entered_implant_chest = false


func _on_kill_the_old_man_reminder_body_entered(body):
	if body.is_in_group("player"):
		if HAS_KILLED_OLD_MAN == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/kill_the_old_man_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()


func _on_old_man_placeholder_area_entered(area):
	if area.name == "Hitbox":
		print("old man killed haha")
		HAS_KILLED_OLD_MAN = true
