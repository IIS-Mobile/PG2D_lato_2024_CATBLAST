extends StaticBody2D
var implant_name: String = "Ultra Elastic Joints"

# Called when the node enters the scene tree for the first time.
func _ready():
	for implant in GlobalVariables.IMPLANTS:
		if !implant.possessed:	
			if implant.name == implant_name:
				$Area2D/CollisionShape2D/Sprite2D.texture = load(implant.graphic_path)
		else:
			self.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Implants.implant_picked(implant_name)
		Implants.implant_equipped(implant_name)
		self.queue_free()
	pass # Replace with function body.
