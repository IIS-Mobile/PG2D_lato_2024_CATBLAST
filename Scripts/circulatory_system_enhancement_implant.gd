extends StaticBody2D
var implant_name: String = "Circulatory System Enhancement"

func _ready():
	for implant in GlobalVariables.IMPLANTS:
		if !implant.posessed:
			if implant.name == implant_name:
				$Area2D/CollisionShape2D/Sprite2D.texture = load(implant.graphic_path)
		else:
			self.queue_free()

func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GlobalVariables.item_pickup_signal.emit(implant_name)
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.ITEM_PICKUP)
		self.queue_free()
