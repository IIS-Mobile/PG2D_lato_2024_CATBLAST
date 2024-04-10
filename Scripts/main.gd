extends Node2D

@onready var pause_menu  =$"."
var paused = false;

func _ready():
	$Panel/Control/Play.grab_focus()
func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/TestLevel.tscn")
func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to_file("res://Scenes/TestLevel.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		
		pauseMenu()
func pauseMenu():
	print("esc")
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
