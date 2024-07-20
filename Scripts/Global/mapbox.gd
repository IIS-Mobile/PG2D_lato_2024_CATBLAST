extends StaticBody2D
@onready var is_player_in_mapbox_range = false

func _process(delta):
	if (is_player_in_mapbox_range and Input.is_action_just_pressed("Interact")):
		#show map logic
		print("Player used mapbox")
		pass
		
			


func _on_interactionbox_body_entered(body):
	if body.is_in_group("player"):
		is_player_in_mapbox_range = false



func _on_interactionbox_body_exited(body):
	if body.is_in_group("player"):
		is_player_in_mapbox_range = false

