extends Control
signal tab_closed

func _ready():
	$Quit.get_node("AnimatedSprite2D").play("Glitch")

func _on_quit_pressed():
	tab_closed.emit()
	hide()


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
