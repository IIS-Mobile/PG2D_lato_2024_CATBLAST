extends StaticBody2D

@export var my_parameter: int = 0
@onready var is_implant_chest_exhausted = false
@onready var is_player_in_grab_range = false
@onready var message_canvas_layer = $CanvasLayer
@onready var message_timer = $MessageTimer
@onready var animation_player = $CanvasLayer/AnimationPlayer
var waiting_for_input = false

func set_my_parameter(value):
	my_parameter = value

func _ready():
	print("Aktualna wartość my_parameter: ", my_parameter)
	message_timer.connect("timeout", Callable(self, "_on_message_timer_timeout"))
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta):
	if !is_implant_chest_exhausted and is_player_in_grab_range and Input.is_action_just_pressed("Interact"):
		$Opened.visible = true
		GlobalVariables.item_pickup_signal.emit(GlobalVariables.IMPLANTS[my_parameter].name)
		SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.ITEM_PICKUP)
		show_message("Item picked: " + GlobalVariables.IMPLANTS[my_parameter].name)
		is_implant_chest_exhausted = true

func _on_grab_the_item_area_body_entered(body):
	if body.is_in_group("player"):
		is_player_in_grab_range = true

func _on_grab_the_item_area_body_exited(body):
	if body.is_in_group("player"):
		is_player_in_grab_range = false

func show_message(text):
	message_canvas_layer.visible = true
	var message_label = message_canvas_layer.get_node("MessageLabel")
	message_label.text = text
	$CanvasLayer/ImplantSprite.texture = load(GlobalVariables.IMPLANTS[my_parameter].graphic_path)
	
	# Play the animation to scale up the CanvasLayer
	animation_player.play("show_message")
	
	message_timer.start(1)  # Start the timer for 1 second

func _on_message_timer_timeout():
	# Do nothing on timer timeout
	pass

func _on_animation_finished(anim_name):
	if anim_name == "show_message":
		waiting_for_input = true

func hide_message():
	message_canvas_layer.visible = false
	waiting_for_input = false

func _input(event):
	if waiting_for_input and (event is InputEventMouseButton or event is InputEventKey):
		hide_message()
