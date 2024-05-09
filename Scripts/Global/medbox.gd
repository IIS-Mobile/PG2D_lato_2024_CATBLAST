extends StaticBody2D
@onready var is_player_in_medbox_range = false
@onready var is_medbox_exhausted = false
@onready var particles = $CPUParticles2D
@onready var heal_value = 1

var particles_display_time = 1.2
var current_display_time = 0.0
var sound_effect_played = false

func _ready():
	particles.emitting = false
	pass # Replace with function body.

func _process(delta):
	if is_player_in_medbox_range and not is_medbox_exhausted and Input.is_action_just_pressed("Interact") and GlobalVariables.CURRENT_HEALTH < GlobalVariables.MAX_HEALTH:
		GlobalVariables.CURRENT_HEALTH += heal_value
		if not sound_effect_played:
			SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HEAL)
			sound_effect_played = true
		particles.emitting = true
		is_medbox_exhausted = true
	if is_medbox_exhausted:
		$Light.visible = false
		$black_screen_sprite.visible = true
	else:
		$black_screen_sprite.visible = false
		
	if particles.emitting == true:
		current_display_time += delta
		if current_display_time >= particles_display_time:
			particles.emitting = false
	
	pass

func _on_healbox_body_entered(body):
	if body.is_in_group("player"):
			is_player_in_medbox_range = true
	pass # Replace with function body.

func _on_healbox_body_exited(body):
	if body.is_in_group("player"):
		is_player_in_medbox_range = true
	pass # Replace with function body.

