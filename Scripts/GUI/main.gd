extends Node2D

class_name GameManager

signal toggle_game_paused(is_paused: bool)
var audio_player: AudioStreamPlayer2D

var game_paused : bool = false :
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused",game_paused)
	
func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused

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
		
		for child in get_children():
			if "Level" in child.name:
				remove_child(child)
		
		var new_scene = load(GlobalVariables.LEVELS[GlobalVariables.LEVEL_TO_CHANGE].path).instantiate()
		self.add_child(new_scene)
		var player_node = get_node("Player")
		player_node.position = GlobalVariables.LEVELS[GlobalVariables.LEVEL_TO_CHANGE].player_start_position
		
		GlobalVariables.CURRENT_LEVEL = GlobalVariables.LEVEL_TO_CHANGE
		
	pass
