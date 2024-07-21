extends Node2D

var HAS_TALKED_WITH_CAPIBO_FIRST_TIME = false
var HAS_SPOKE_ABOUT_MOTIVE = false
var HAS_KILLED_OLD_MAN = false
var HAS_KILLED_RATFACE = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.BATTLE)

	# connect signals old man
	var old_man_npc = get_node("Old_man_npc")
	var callable_old_man_killed = Callable(self, "_on_old_man_killed")
	old_man_npc.connect("old_man_killed", callable_old_man_killed)

	# connect signals ratface
	var ratface_npc = get_node("ratface_npc")
	var callable_ratface_killed = Callable(self, "_on_ratface_killed")
	ratface_npc.connect("ratface_killed", callable_ratface_killed)



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
		if $WorldTiles/Objects/implant_chest.is_implant_chest_exhausted == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/grab_the_implant_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()

func _on_kill_the_old_man_reminder_body_entered(body):
	if body.is_in_group("player"):
		if HAS_KILLED_OLD_MAN == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/kill_the_old_man_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()

func _on_old_man_killed():
	if !HAS_KILLED_OLD_MAN:
		print("old man killed haha")
		HAS_KILLED_OLD_MAN = true

func _on_ratface_killed():
	if !HAS_KILLED_RATFACE:
		print("ratface killed haha")
		var tilemap_node = get_node("WorldTiles")
		tilemap_node.change_after_ratface_death()
		HAS_KILLED_RATFACE = true


func _on_grab_second_implant_reminder_body_entered(body):
	if body.is_in_group("player"):
		if $WorldTiles/Objects/implant_chest2.is_implant_chest_exhausted == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/grab_the_second_implant_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()


func _on_grab_third_implant_reminder_body_entered(body):
	if body.is_in_group("player"):
		if $WorldTiles/Objects/implant_chest3.is_implant_chest_exhausted == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/grab_the_third_implant_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = false
			body.velocity.x = 1200
			body.move_and_slide()




func _on_grab_fourth_implant_reminder_body_entered(body):
	if body.is_in_group("player"):
		if $WorldTiles/Objects/implant_chest4.is_implant_chest_exhausted == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/grab_the_fourth_implant_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()


func _on_grab_fivesix_implant_reminder_body_entered(body):
	if body.is_in_group("player"):
		if ($WorldTiles/Objects/implant_chest5.is_implant_chest_exhausted == false
		or $WorldTiles/Objects/implant_chest6.is_implant_chest_exhausted == false):
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/grab_the_fivesix_implant_reminder.txt")
			body.get_node("AnimatedSprite2D").flip_h = true
			body.velocity.x = -1200
			body.move_and_slide()


func _on_vipers_motive_body_entered(body):
	if body.is_in_group("player"):
		if HAS_SPOKE_ABOUT_MOTIVE == false:
			GlobalVariables.PLAYER_CONTROLS_ENABLED = false
			TextboxNarrative.dialogue_begin("res://Assets/Dialogue/1Level/vipers_motive.txt")
			HAS_SPOKE_ABOUT_MOTIVE = true
