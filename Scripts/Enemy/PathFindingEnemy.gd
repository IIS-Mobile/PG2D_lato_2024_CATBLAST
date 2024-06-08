extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
var path_find
var player
var target = null
var prevTarget = null
var path : Array

func _draw():
	for i in range(path.size()-1):
		draw_line(path[i].position,path[i+1].position,Color.BROWN)
 


func _ready():
	player = get_node("/root/GameManager/Player")
	path_find = get_parent().get_node("WorldTiles")
	print("Ready enemy")


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const speed = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func go_to_next_point_in_path():
	if path.is_empty():
		prevTarget = null
		target = null
		return
	prevTarget = target
	target = path.pop_back()
	queue_redraw()
	

func jump_right_edge():
	return prevTarget.right_edge and target.left_edge and prevTarget.position.y <= target.position.y and prevTarget.position.x < target.position.x

func jump_left_edge():
	return prevTarget.left_edge && target.right_edge and prevTarget.position.y <= target.position.y and prevTarget.position.x > target.position.x
	

func jump(v : Vector2):
	if target == null or prevTarget == null:
		return v.y
	if prevTarget.position.y < target.position.y and Vector2(prevTarget.position).distance_to(target.position) < 120:
		return v.y
	if prevTarget.position.y < target.position.y and target.fall_point:
		return v.y
	if prevTarget.position.y > target.position.y or jump_left_edge() or jump_right_edge():
		print("jump should be done!!!!!!")
		var h_distance = path_find.local_to_map(target.position).y - path_find.local_to_map(prevTarget.position).y
		if abs(h_distance) <= 1:
			return -350
		elif abs(h_distance) == 2:
			return -390
		else:
			return -600
	return v.y
const player_offset = Vector2.DOWN * 16
func do_path_finding():
	var player_pos = player.position + player_offset
	path = path_find.get_platform_2d_path(position,player_pos)
	go_to_next_point_in_path()

func _physics_process(delta):
	var dir = Vector2.ZERO
	
	if not is_on_floor():
		velocity.y += gravity*delta
		
	#do_path_finding()
	
	
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

