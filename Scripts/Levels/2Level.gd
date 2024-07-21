extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.UNDERGROUND)
	TextboxNarrative.dialogue_finished.connect(_on_dialogue_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_next_level_body_entered(body):
	if body.is_in_group("player"):
		GlobalVariables.PLAYER_CONTROLS_ENABLED = false
		TextboxNarrative.dialogue_begin("res://Assets/Dialogue/2Level/train_leaves_later.txt")
		
func _on_dialogue_finished():
	GlobalVariables.LEVEL_TO_CHANGE = 0;
