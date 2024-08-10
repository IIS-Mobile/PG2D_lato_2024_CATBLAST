extends Control


func _ready():
	pass # Replace with function body.

func _process(delta):
	pass


func _on_quit_pressed():
	hide()


func _on_quit_mouse_entered():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
