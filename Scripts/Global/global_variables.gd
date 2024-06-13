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
	var slot_type: int
	var posessed: bool
	var equipped: bool

	func _init(name: String, graphic_path: String, cooldown: float, slot_type: int, posessed: bool, equipped: bool):
		self.name = name
		self.graphic_path = graphic_path
		self.cooldown = cooldown
		self.slot_type = slot_type
		self.posessed = posessed
		self.equipped = equipped

signal item_pickup_signal(name: String)
signal item_equip_signal(name: String)
signal open_implant_inventory_signal()

signal toggle_game_paused_signal(is_paused: bool)
var GAME_PAUSED : bool = false :
	get:
		return GAME_PAUSED
	set(value):
		GAME_PAUSED = value
		get_tree().paused = GAME_PAUSED
		toggle_game_paused_signal.emit(GAME_PAUSED)

var INVENTORY_LOOKUP_FLAG = false
var IS_INVENTORY_OPEN = false
var PLAYER_CONTROLS_ENABLED = true
var IS_PLAYER_TALKING = false
var CAN_PLAYER_DASH = true
var PLAYER_SPEED = 300.0

var FIRST_DIALOGUE_FLAG = false

var MAX_HEALTH: int = 7
var CURRENT_HEALTH: int = MAX_HEALTH

#CURRENT_LEVEL defines the level that loads upon launching the game
var CURRENT_LEVEL: int = 4
var LEVEL_TO_CHANGE: int = CURRENT_LEVEL

var LEVELS = [
	LevelObject.new("res://Scenes/Levels/LobbyLevel.tscn", Vector2(441, 317)),
	LevelObject.new("res://Scenes/Levels/1Level.tscn", Vector2(700, 33)),
  	LevelObject.new("res://Scenes/Levels/2Level.tscn", Vector2(-40, 100)),
	LevelObject.new("res://Scenes/Levels/PathfindingTestLevel.tscn", Vector2(541, 346)),
	LevelObject.new("res://Scenes/Levels/TestLevel.tscn", Vector2(0, 368)),
]

var IMPLANTS = [
	ImplantObject.new("Full Precision Mechanical Arms","res://Assets/Arts/Items/arm_implant1.png", 0, 1, false, false),
	ImplantObject.new("Carbon Fiber Arm Muscles","res://Assets/Arts/Items/arm_implant2.png", 0, 1, false, false),
	ImplantObject.new("Circulatory System Enhancement","res://Assets/Arts/Items/chest_implant1.png", 0, 2, false, false),
	ImplantObject.new("Ribcage Energy Shield","res://Assets/Arts/Items/chest_implant2.png", 0, 2, false, false),
	ImplantObject.new("Ultra Elastic Joints","res://Assets/Arts/Items/leg_implant1.png", 0, 3, false, false),
	ImplantObject.new("Light Titanium Leg Bones","res://Assets/Arts/Items/leg_implant2.png", 0, 3, false, false)
]
