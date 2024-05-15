extends Node

class LevelObject:
	var id: int
	var path: String
	var player_start_position: Vector2

	func _init(path: String, player_start_position: Vector2):
		self.path = path
		self.player_start_position = player_start_position

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
	LevelObject.new("res://Scenes/Levels/PathfindingTestLevel.tscn", Vector2(541, 346))
]

