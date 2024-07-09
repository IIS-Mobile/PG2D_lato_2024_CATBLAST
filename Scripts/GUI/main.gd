extends Node2D

class_name GameManager

var audio_player: AudioStreamPlayer2D
	
func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		GlobalVariables.GAME_PAUSED = !GlobalVariables.GAME_PAUSED

func _ready():
	randomize()
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.PEACE)

func _on_hover():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
	
func _process(delta):
	load_lvl()
	pass
	
func load_lvl():
	if(GlobalVariables.CURRENT_LEVEL != GlobalVariables.LEVEL_TO_CHANGE):
		
		var current_level = get_node("CurrentLevel")
		for child in current_level.get_children():
			current_level.remove_child(child)
		
		var new_scene = load(GlobalVariables.LEVELS[GlobalVariables.LEVEL_TO_CHANGE].path).instantiate()
		current_level.add_child(new_scene)
		var player_node = get_node("Player")
		player_node.position = GlobalVariables.LEVELS[GlobalVariables.LEVEL_TO_CHANGE].player_start_position
		
		GlobalVariables.CURRENT_LEVEL = GlobalVariables.LEVEL_TO_CHANGE
		
	pass
