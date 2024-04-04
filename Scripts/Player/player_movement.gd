extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -500.0

@onready var anim = get_node("AnimationPlayer")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor() :
		velocity.y = JUMP_VELOCITY
		if anim.current_animation != "Attack"and anim.current_animation != "attack_left":
			anim.play("Jump")

		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	var dir = get_node("AnimatedSprite2D").flip_h
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1 :
		get_node("AnimatedSprite2D").flip_h = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if(dir == false) :
			anim.play("Attack")
		else:
			anim.play("attack_left")
	if direction:
		velocity.x = direction * SPEED
		if( velocity.y == 0) and anim.current_animation != "Attack"  and anim.current_animation != "attack_left":
			anim.play("Run")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if( velocity.y== 0) and anim.current_animation != "Attack"and anim.current_animation != "attack_left":
			anim.play("Idle")
	if(velocity.y > 0) and anim.current_animation != "Attack"and anim.current_animation != "attack_left":
		anim.play("Fall")
	move_and_slide()


func _on_weapon_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		print("Hit enemy")
		body.queue_free()
	pass # Replace with function body.
