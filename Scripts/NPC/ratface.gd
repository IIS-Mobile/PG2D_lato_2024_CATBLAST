extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var is_dead = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree : AnimationTree = $AnimationTree

func _ready():
	animation_tree.active = true

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if(animation_tree.get("parameters/conditions/death")):
		velocity.x = 0

	move_and_slide()


func kill():
	animation_tree.set("parameters/conditions/death", true)
	animation_tree.set("parameters/conditions/idle", false)
	is_dead = true