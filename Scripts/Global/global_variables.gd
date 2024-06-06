extends Node

class LevelObject:
	var id: int
	var path: String
	var player_start_position: Vector2

	func _init(path: String, player_start_position: Vector2):
		self.path = path
		self.player_start_position = player_start_position
		
class ImplantObject:
	var name: String
	var graphic_path: String
	var cooldown: float
	var possessed: bool
	var equipped: bool

	func _init(name: String, graphic_path: String, cooldown: float, possessed: bool, equipped: bool):
		self.name = name
		self.graphic_path = graphic_path
		self.cooldown = cooldown
		self.possessed = possessed
		self.equipped = equipped

var PLAYER_CONTROLS_ENABLED = true
var IS_PLAYER_TALKING = false
var CAN_PLAYER_DASH = true

var MAX_HEALTH: int = 7
var CURRENT_HEALTH: int = MAX_HEALTH

var CURRENT_LEVEL: int = 1
var LEVEL_TO_CHANGE: int = CURRENT_LEVEL

var LEVELS = [
	
	LevelObject.new("res://Scenes/Levels/LobbyLevel.tscn", Vector2(441, 317)),
	
	LevelObject.new("res://Scenes/Levels/TestLevel.tscn", Vector2(0, 368)),
	LevelObject.new("res://Scenes/Levels/1Level.tscn", Vector2(700, 33)),
	LevelObject.new("res://Scenes/Levels/2Level.tscn", Vector2(-40, 100)),
	
]

var IMPLANTS = [
	ImplantObject.new("Full Precision Mechanical Arms","res://Assets/Arts/Items/arm_implant1.png", 0, false, false),
	ImplantObject.new("Circulatory System Enhancement","res://Assets/Arts/Items/chest_implant1.png", 0, false, false),
	ImplantObject.new("Ultra Elastic Joints","res://Assets/Arts/Items/leg_implant1.png", 0, false, false),
]

