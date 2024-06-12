extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_player_in_dialogue_range = false
var dialogue_path = "res://Assets/Dialogue/debug_dialogue.txt"

func _process(delta):
	play_animation()
	
	if (
		is_player_in_dialogue_range
		and Input.is_action_just_pressed("Interact")
		and not GlobalVariables.IS_PLAYER_TALKING
	):
		GlobalVariables.IS_PLAYER_TALKING = true
		$Textbox.dialogue_begin(dialogue_path)


func _physics_process(delta):

	
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_chat_detection_area_body_entered(body):
	if body.is_in_group("player"):
		is_player_in_dialogue_range = true
		print("Player entered dialogue range and can talk")


func _on_chat_detection_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("player"):
		is_player_in_dialogue_range = false
		print("Player left dialogue range")
		
func play_animation():
	animation_player.play("idle")
	var current_frame: int = animation_player.get_frame()

	match current_frame:
		10, 11:
			$PointLight2D.set_position(Vector2(8, 8))
		0, 1, 2, 9, 12, 19:
			$PointLight2D.set_position(Vector2(8, 5))
		3, 8, 13, 18:
			$PointLight2D.set_position(Vector2(-1.5, 0.2))
		_:
			$PointLight2D.set_position(Vector2(0, 0))
			
