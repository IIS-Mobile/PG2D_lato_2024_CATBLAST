extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label

@onready var dialogue_tween = get_tree().create_tween()
@onready var end_symbol_tween = get_tree().create_tween()

@onready var letters_pop_sound: AudioStream = load("res://Assets/Sounds/ui/dialogue letters sound effect - floraphonic.wav")

enum State {
	READY,
	READING,
	FINISHED
}

var sound_timer: Timer
var audio_player: AudioStreamPlayer2D
var current_state = State.READY
var text_queue = []

func dialogue_begin():
	print("Starting state: State.READY")
	hide_textbox()
	queue_text("This is an NPC dialogue test.")
	queue_text("Pressing Interact as the letters pop up makes the whole text appear at once.")
	queue_text("Player is free to move around and interrupt the dialogue if he wanders too far away.")
	queue_text("To be able to start the dialogue again, the player must leave NPC's dialogue range.")
	queue_text("Mangusta shall perish.")

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
	label.text = next_text
	label.visible_characters = 0
	change_state(State.READING)
	show_textbox()
	dialogue_tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE).from(0).finished
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
	
func playsound(sound):
	audio_player.stream = sound
	audio_player.play()


func _on_timer_timeout():
	playsound(letters_pop_sound)
