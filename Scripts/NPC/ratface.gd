extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var is_dead = false

var BLOOD_DISPLAY_TIME = 0.5
var CURRENT_DISPLAY = 0.0

signal ratface_killed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree : AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true
	$BloodSplatter.emitting = false

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if(animation_tree.get("parameters/conditions/death")):
		velocity.x = 0

	if $BloodSplatter.emitting == true:
		CURRENT_DISPLAY += delta
		if CURRENT_DISPLAY >= BLOOD_DISPLAY_TIME:
			$BloodSplatter.emitting = false
			CURRENT_DISPLAY = 0.0

	move_and_slide()

func kill():
	if !is_dead:
		animation_tree.set("parameters/conditions/death", true)
		animation_tree.set("parameters/conditions/idle", false)
		is_dead = true
		$BloodSplatter.emitting = true
		emit_signal("ratface_killed")