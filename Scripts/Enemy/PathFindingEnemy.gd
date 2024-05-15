extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
var path_find
var player
var target = null
var prevTarget = null
var path : Array

func _ready():
	player = get_parent().get_parent().find_child("Player")
	path_find = get_parent().get_node("WorldTiles")
	print("Ready enemy")


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func go_to_next_point_in_path():
	if path.is_empty():
		print(self, " loosing target")
		prevTarget = null
		target = null
		return
	prevTarget = target
	target = path.pop_back()
	

func jump_right_edge():
	print("jump right edge")
	pass

func jump_left_edge():
	print("jump left edge")
	pass

func jump(v : Vector2):
	print("jump")
	if target == null or prevTarget == null:
		return v.y
	if prevTarget.position.y < target.position.y and prevTarget.position.distance_to(target.position) < 500:
		return v.y
	if prevTarget.position.y < target.position.y and target.fall_point:
		return v.y
	if prevTarget.position.y >= target.position.y or jump_left_edge() or jump_right_edge():
		print("jump should be done!!!!!!")
		var h_distance = path_find.local_to_map(target.position).y - path_find.local_to_map(prevTarget.position).y
		if abs(h_distance) <= 1:
			return -350
		elif abs(h_distance) == 2:
			return -390
		else:
			return -500
const player_offset = Vector2.DOWN * 16
func do_path_finding():
	var player_pos = path_find.local_to_map(player.position + player_offset)
	path = path_find.get_platform_2d_path(path_find.local_to_map(position),player_pos)
	print(path.size())
	go_to_next_point_in_path()

func _physics_process(delta):
	var dir = Vector2.ZERO
	
	if not is_on_floor():
		velocity.y += gravity*delta
		
	do_path_finding()
	
	
	if target != null:
		if target.position.x - 16 > position.x:
			dir.x = 1
		elif target.position.x + 16 < position.x:
			dir.x = -1
		else:
			if is_on_floor():
				go_to_next_point_in_path()
				velocity.y = jump(velocity)
	if dir != Vector2.ZERO:
		velocity.x = dir.x * speed
	else:
		velocity.x = move_toward(velocity.x,0,speed)


	move_and_slide()

	
	
		
	
	
