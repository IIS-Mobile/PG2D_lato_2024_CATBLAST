extends Control

var hp_point_width: int = 6
var previous_health: int = GlobalVariables.CURRENT_HEALTH

@onready var animated_lifebar = $AnimatedLifebar


func _process(delta):
	#dash animation
	#$DashLoading to animated sprite 2d
	if GlobalVariables.CAN_PLAYER_DASH:
		$DashLoading.frame = 8
	else:
		$DashLoading.speed_scale = $DashLoading.sprite_frames.get_frame_count("Loading") / 1.5
		$DashLoading.play("Loading")

	if animated_lifebar.is_playing():
		$Lifebar.visible = false
		animated_lifebar.visible = true
	else:
		$Lifebar.visible = true
		animated_lifebar.visible = false

	if previous_health > GlobalVariables.CURRENT_HEALTH:
		animated_lifebar.play("Glitch")

	if GlobalVariables.CURRENT_HEALTH > 0:
		previous_health = GlobalVariables.CURRENT_HEALTH
		$health_points.size.x = hp_point_width * GlobalVariables.CURRENT_HEALTH
		$health_points.visible = true
	else:
		$health_points.texture = null
