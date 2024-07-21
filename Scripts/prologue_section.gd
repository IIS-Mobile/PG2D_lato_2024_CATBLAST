extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.PROLOGUE)
	$AnimationPlayer.play("Fade_in")
	await get_tree().create_timer(5).timeout 
	TextboxNarrative.dialogue_begin("res://Assets/Dialogue/prologue.txt")
	TextboxNarrative.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	$AnimationPlayer.play("Fade_out")
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return
