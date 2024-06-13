extends Control

@export var game_manager: GameManager


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$Panel.get_node("Control/AnimatedSprite2D").play("Glitch")
	$Panel.get_node("Control/AnimatedSprite2D2").play("Glitch")
	$Panel.get_node("Control/AnimatedSprite2D3").play("Glitch")
	GlobalVariables.toggle_game_paused_signal.connect(_on_game_manager_toggle_game_paused)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_manager_toggle_game_paused(is_paused: bool):
	if is_paused:
		show()
	else:
		hide()


func _on_resume_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	GlobalVariables.GAME_PAUSED = false
	print("res")
	
func _on_options_button_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)	

func _on_quit_pressed():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.CONFIRM)
	get_tree().quit()



func _on_resume_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_options_button_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
