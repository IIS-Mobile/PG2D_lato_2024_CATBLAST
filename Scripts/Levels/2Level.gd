extends Node2D

var player_in_left_switch_range = false
var player_in_right_switch_range = false
var right_lock = true
var left_lock = true

# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.UNDERGROUND)
	TextboxNarrative.dialogue_finished.connect(_on_dialogue_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_right_switch_range and Input.is_action_just_pressed("Interact"):
		$Right_panel.show()
		right_lock = false
		
	if player_in_left_switch_range and Input.is_action_just_pressed("Interact"):
		$Left_panel.show()
		left_lock = false
		
	if !right_lock and !left_lock:
		$Left_panel/DoorLight.hide()
		$Left_panel/DoorDiodeSprite.hide()
		$Right_panel/DoorLight.hide()
		$Right_panel/DoorDiodeSprite.hide()
		$WorldTiles.set_layer_enabled (9, false)
	
		
	



func _on_next_level_body_entered(body):
	if body.is_in_group("player"):
		GlobalVariables.PLAYER_CONTROLS_ENABLED = false
		TextboxNarrative.dialogue_begin("res://Assets/Dialogue/2Level/train_leaves_later.txt")
		
func _on_dialogue_finished():
	GlobalVariables.LEVEL_TO_CHANGE = 0;


func _on_right_switch_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_right_switch_range = true


func _on_right_switch_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_right_switch_range = false


func _on_left_switch_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_left_switch_range = true


func _on_left_switch_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_left_switch_range = false
