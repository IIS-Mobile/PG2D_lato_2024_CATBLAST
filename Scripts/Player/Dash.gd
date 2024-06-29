extends Node



func _ready():
	ghosting()

func _on_process(delta):
	pass

func set_property(tx_pos, tx_scale, tx_current, tx_direction):
	$Sprite2D.position = tx_pos
	$Sprite2D.scale = tx_scale
	$Sprite2D.texture = tx_current
	if tx_direction == Vector2(-1, 0):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false


func ghosting():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property($Sprite2D, "self_modulate", Color(1, 1, 1, 0), 0.45)
	await tween_fade.finished
	queue_free()
