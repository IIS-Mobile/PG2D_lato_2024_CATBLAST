extends StaticBody2D
var implant_name: String = "Ultra Elastic Joints"

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
		Inventory.add_item(implant_name)
		self.queue_free()
