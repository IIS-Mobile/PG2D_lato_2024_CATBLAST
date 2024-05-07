extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_player_in_dialogue_range = false

func _process(delta):
	if is_player_in_dialogue_range and Input.is_action_just_pressed("Interact") and not GlobalVariables.IS_PLAYER_TALKING:
		GlobalVariables.IS_PLAYER_TALKING = true
		$Textbox.dialogue_begin()

func _physics_process(delta):
	animation_player.play("idle")
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_chat_detection_area_body_entered(body):
	if body.is_in_group("player"):
		is_player_in_dialogue_range = true
		print("Player entered dialogue range and can talk")

func _on_chat_detection_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("player"):
		is_player_in_dialogue_range = false
		#$Textbox.text_queue.clear()
		#$Textbox.hide_textbox()
		#$Textbox.sound_timer.stop()
		print("Player left dialogue range")
