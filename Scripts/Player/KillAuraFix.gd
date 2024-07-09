extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const attack_animations = ["Attack","attack_left","Attack_Jump","Attack_Run","Attack_Run_L","Attack_Jump_L"]

var last_animation = ""
@onready var player := get_parent()
func _on_animation_changed(new_name):
	if last_animation in attack_animations:
		var hbox = player.get_node("Sprite2D/Hitbox")
		hbox.visible = false
		for attack in hbox.get_children():
			attack.disabled = true
	last_animation = new_name

