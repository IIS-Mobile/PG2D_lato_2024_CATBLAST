extends Node2D

class_name GameManager

var audio_player: AudioStreamPlayer2D
	
var CURRENT_HEALTH = 0
var LEVEL_TO_CHANGE = 0
var save_path = "user://variable.save"
var loaded_data = false

func load_data():
	print("x")
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var CURRENT_HEALTH = file.get_var()
			var LEVEL_TO_CHANGE = file.get_var()
			print("Loaded Health:", CURRENT_HEALTH)
			print("Loaded Level:", LEVEL_TO_CHANGE)
			
			for implant in GlobalVariables.IMPLANTS:
				var implant_val = file.get_var()
				print("Loaded Implant Value:", implant_val)
				if implant_val == 1:
					GlobalVariables.item_pickup_signal.emit(implant.name)
			file.close()
			GlobalVariables.CURRENT_HEALTH = CURRENT_HEALTH
			GlobalVariables.LEVEL_TO_CHANGE = LEVEL_TO_CHANGE
			loaded_data = true
			print("Data loaded successfully.")
		else:
			print("Failed to open file for reading")
	else:
		print("Save file does not exist")


func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		GlobalVariables.GAME_PAUSED = !GlobalVariables.GAME_PAUSED

func _ready():
	#load_data()
	randomize()
	SoundtrackPlayer.play_soundtrack(SOUNDTRACKPLAYER_CLASS.THEMES.PEACE)

func _on_hover():
	SoundEffectPlayer.playsound(SFX_CLASS.SOUNDS.HOVER)
	
func _process(delta):
	load_lvl()
	pass

func load_lvl():
	if(GlobalVariables.CURRENT_LEVEL != GlobalVariables.LEVEL_TO_CHANGE or GlobalVariables.RELOAD):
		GlobalVariables.RELOAD = false

		if(GlobalVariables.LEVEL_TO_CHANGE == 3):
			GlobalVariables.TRAIN_SPEED = 500
		else:
			GlobalVariables.TRAIN_SPEED = 500

		var current_level = get_node("CurrentLevel")
		for child in current_level.get_children():
			current_level.remove_child(child)
		
		var new_scene = load(GlobalVariables.LEVELS[GlobalVariables.LEVEL_TO_CHANGE].path).instantiate()
		current_level.add_child(new_scene)
		var player_node = get_node("Player")
		player_node.position = GlobalVariables.LEVELS[GlobalVariables.LEVEL_TO_CHANGE].player_start_position
		GlobalVariables.CURRENT_LEVEL = GlobalVariables.LEVEL_TO_CHANGE
	pass
