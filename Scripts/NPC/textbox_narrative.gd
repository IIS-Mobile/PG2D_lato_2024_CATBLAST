extends CanvasLayer
class_name TEXTBOXNARRATIVE_CLASS

const CHAR_READ_RATE = 0.05

signal dialogue_finished

@onready var textbox_container = $TextboxContainer
@onready var choice_box = $LevelDebugDialogueControl
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

@onready var dialogue_tween = get_tree().create_tween()
@onready var end_symbol_tween = get_tree().create_tween()

enum State { READY, READING, FINISHED }

var sound_timer: Timer
var audio_player: AudioStreamPlayer2D
var current_state = State.READY
var text_queue = []


func dialogue_begin(dialogue_path):
	GlobalVariables.PLAYER_CONTROLS_ENABLED = false
	print("Starting state: State.READY")
	hide_textbox()
	load_file(dialogue_path)


func _ready():
	audio_player = $LetterSound
	sound_timer = $LetterTimer
	sound_timer.wait_time = CHAR_READ_RATE
	print("Starting state: State.READY")
	end_symbol_tween = get_tree().create_tween()
	end_symbol_tween.tween_property(end_symbol, "position", Vector2(1048, 50), 0.2)
	end_symbol_tween.tween_property(end_symbol, "position", Vector2(1048, 70), 0.2)
	end_symbol_tween.set_loops(9999)
	hide_textbox()


func _process(delta):
	end_symbol_tween.set_loops(9999)
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("Interact"):
				dialogue_tween.kill()
				label.visible_characters = -1
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			sound_timer.stop()
			if text_queue.is_empty() and Input.is_action_just_pressed("Interact"):
				manage_portraits(-1)
				GlobalVariables.PLAYER_CONTROLS_ENABLED = true
				GlobalVariables.IS_PLAYER_TALKING = false
				dialogue_finished.emit()
			if Input.is_action_just_pressed("Interact"):
				change_state(State.READY)
				hide_textbox()


func queue_text(next_text):
	text_queue.push_back(next_text)


func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()


func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()


func display_text():
	dialogue_tween = get_tree().create_tween()
	var next_text = text_queue.pop_front()
	
	var portrait_number = seek_for_name(next_text)
	manage_portraits(portrait_number)
	
	label.text = next_text
	label.visible_characters = 0
	change_state(State.READING)
	show_textbox()
	(
		dialogue_tween
		. tween_property(
			label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE
		)
		. from(0)
		. finished
	)
	dialogue_tween.connect("finished", on_tween_finished)
	sound_timer.start()


func on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)


func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")


func _on_timer_timeout():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.LETTERS_POP)

func load_file(file):
	var f = FileAccess.open(file, FileAccess.READ)
	while not f.eof_reached():
		var line = f.get_line()
		if line == "":
			break
		queue_text(line)
	f.close()
	return

func seek_for_name(text):
	if(text[0] == 'V' && text[1] == 'I' && text[2] == 'P' && text[3] == 'E'):
		return 0
	elif(text[0] == 'C' && text[1] == 'A' && text[2] == 'P' && text[3] == 'I'):
		return 1
	elif(text[0] == 'M' && text[1] == 'O' && text[2] == 'L' && text[3] == 'L'):
		return 2
	elif(text[0] == 'R' && text[1] == 'A' && text[2] == 'T' && text[3] == 'F'):
		return 3
	else:
		return -2

func manage_portraits(number): 
	match number:
		0:
			$ViperPanel.show()
			$CapiboPanel.hide()
			$MollyPanel.hide()
			$RatfacePanel.hide()
		1:
			$ViperPanel.hide()
			$CapiboPanel.show()
			$MollyPanel.hide()
			$RatfacePanel.hide()
		2:
			$ViperPanel.hide()
			$CapiboPanel.hide()
			$MollyPanel.show()
			$RatfacePanel.hide()
		3:
			$ViperPanel.hide()
			$CapiboPanel.hide()
			$MollyPanel.hide()
			$RatfacePanel.show()
		-1:
			$ViperPanel.hide()
			$CapiboPanel.hide()
			$MollyPanel.hide()
			$RatfacePanel.hide()
		-2:
			return
