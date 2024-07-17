extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.PROLOGUE)
	$AnimationPlayer.play("Fade_in")
	await get_tree().create_timer(6).timeout
	TextboxNarrative.dialogue_begin("res://Assets/Dialogue/prologue.txt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
