# algorithm taken from https://github.com/solarstrings/Godot4.x_Advanced2DPlatformerPathFinding/blob/main/Scenes/TileMapPathFind/TileMapPathFind.cs


extends TileMap

func _init():
	cells = get_used_cells(LAYER)
	generateGraph()
	print("Done generating graph")
	connect_points()
	print("Done connecting points :) yippie")

class Tile_data:
	var left_wall  : bool
	var right_wall : bool
	var left_edge  : bool
	var right_edge : bool
	var fall_point : bool
	var point_id   : int
	var position   : Vector2i
	
	
	func _init(point_id : int, position: Vector2):
		self.point_id = point_id	
		self.position = position
		left_wall = false
		left_edge = false
		right_wall = false
		right_edge = false
		fall_point = false

const LAYER = 0

var tile_list : Array[Tile_data]

# Called when the node enters the scene tree for the first time.
var player_node_id 
var connected_node_id
var draw_lines_player_index 
func _ready():
	player_node_id = astar.get_available_point_id()
	astar.add_point(player_node_id,get_node('/root/GameManager/Player').position)
	connected_node_id = astar.get_closest_point(get_node('/root/GameManager/Player').position)
	astar.connect_points(player_node_id,connected_node_id)
	
	draw_lines_player_index = draw_lines_list.size()
	draw_lines_list.append([get_node('/root/GameManager/Player').position,astar.get_point_position(connected_node_id)])
	


func _physics_process(delta):
	astar.disconnect_points(player_node_id,connected_node_id)
	astar.set_point_disabled(player_node_id)
	connected_node_id = astar.get_closest_point(get_node('/root/GameManager/Player').position)
	astar.set_point_disabled(player_node_id,false)
	astar.set_point_position(player_node_id,get_node('/root/GameManager/Player').position)
	astar.connect_points(player_node_id,connected_node_id)

	var pos = astar.get_point_position(connected_node_id)

	draw_lines_list[draw_lines_player_index] = [get_node('/root/GameManager/Player').position,astar.get_point_position(connected_node_id)]
	queue_redraw()


var draw_lines_list = []
func _draw():
	for i in draw_lines_list:
		draw_line(i[0],i[1],Color.RED)

func find_by_id(id : int):
	var f = tile_list.map(func (e): return e.point_id == id)
	return tile_list[f.find(true)]

func reverse_path_stack(path_stack : Array):
	var reversed : Array = []
	while not path_stack.is_empty():
		reversed.push_back(path_stack.pop_back())
	return reversed


func get_platform_2d_path(startPos : Vector2, endPos : Vector2):
	var path_stack : Array = []

	var startPosClosestPoint := astar.get_closest_point(startPos)
	var endPosClosestPoint := astar.get_closest_point(endPos)
	
	startPos = local_to_map(astar.get_point_position(startPosClosestPoint))
	endPos = local_to_map(astar.get_point_position(endPosClosestPoint))
	var id_path = astar.get_id_path(startPosClosestPoint,endPosClosestPoint)


	if id_path.is_empty():
		return path_stack
	#print("yippie path is not empty")
	var start_point = get_point_info(startPos)
	var end_point = get_point_info(endPos)
	if end_point == null:
		end_point = Tile_data.new(player_node_id,map_to_local(endPos)) # create new
	
	if start_point == null or end_point == null:
		return []
	var n = id_path.size()
	for i in range(n):
		var cur_point = find_by_id(id_path[i])
		if n == 1:
			continue
		
		if i == 0 and n >= 2:
			var second_path_point = find_by_id(id_path[1])
			if Vector2(start_point.position).distance_to(second_path_point.position) < Vector2(cur_point.position).distance_to(second_path_point.position):
				path_stack.append(start_point)
				continue
		
		elif i == n -1 and n >= 2:
			var penult_point = find_by_id(id_path[i-1])
			if Vector2(end_point.position).distance_to(penult_point.position) < Vector2(cur_point.position).distance_to(penult_point.position):
				continue
			else:
				path_stack.append(cur_point)
				break
		path_stack.append(cur_point)
	path_stack.append(end_point)
	return reverse_path_stack(path_stack)

func get_point_info(cell : Vector2i):
	for tile in tile_list:
		var m = map_to_local(cell)
		if tile.position == Vector2i(map_to_local(cell)):
			return tile



func get_start_scan_tile_for_fall_point(cell :Vector2i):
	var cell_above = Vector2i(cell.x, cell.y - 1)
	var point = get_point_info(cell_above)
	if point == null:
		return
	return Vector2i(cell.x -1, cell.y -1) if point.left_edge else Vector2i(cell.x + 1, cell.y -1) if point.right_edge else Vector2i.ZERO




func tile_above_exists(cell : Vector2i):
	return get_cell_source_id(LAYER,Vector2i(cell.x,cell.y-1)) != -1

func tile_is_in_graph(cell : Vector2i):
	if astar.get_point_count() <= 0:
		return -1
	var local_pos = map_to_local(cell)
	var point_id = astar.get_closest_point(local_pos)
	var point_position = astar.get_point_position(point_id)
	return point_id if point_position == local_pos else -1


func add_left_wall(cell : Vector2i):
	if tile_above_exists(cell):
		return
	if get_cell_source_id(LAYER, Vector2i(cell.x - 1, cell.y - 1)) != -1: 
		var tile_above = Vector2i(cell.x, cell.y - 1)
		var cell_id = tile_is_in_graph(tile_above)
		if cell_id == -1:
			cell_id = astar.get_available_point_id()
			var info = Tile_data.new(cell_id, map_to_local(tile_above))
			info.left_wall = true
			tile_list.append(info)
			astar.add_point(cell_id, map_to_local(tile_above))
		else:
			var f = tile_list.map(func (e): return e.point_id == cell_id)
			tile_list[f.find(true)].left_wall = true

func add_left_edge(cell : Vector2i):
	if tile_above_exists(cell):
		return
	if get_cell_source_id(LAYER,Vector2i(cell.x-1,cell.y)) == -1: # if cell to left is empty 
		var tile_above = Vector2i(cell.x,cell.y-1)
		var cell_id = tile_is_in_graph(tile_above)
		
		if cell_id == -1:
			cell_id = astar.get_available_point_id()
			var info = Tile_data.new(cell_id,map_to_local(tile_above))
			info.left_edge = true
			tile_list.append(info)
			astar.add_point(cell_id,map_to_local(tile_above))
		else:
			var f = tile_list.map(func (e): return e.point_id == cell_id)
			tile_list[f.find(true)].left_edge = true


func add_right_edge(cell: Vector2i):
	if tile_above_exists(cell):
		return
	if get_cell_source_id(LAYER, Vector2i(cell.x + 1, cell.y)) == -1: # if cell to right is empty 
		var tile_above = Vector2i(cell.x, cell.y - 1)
		var cell_id = tile_is_in_graph(tile_above)
		if cell_id == -1:
			cell_id = astar.get_available_point_id()
			var info = Tile_data.new(cell_id, map_to_local(tile_above))
			info.right_edge = true
			tile_list.append(info)
			astar.add_point(cell_id, map_to_local(tile_above))
		else:
			var f = tile_list.map(func (e): return e.point_id == cell_id)
			tile_list[f.find(true)].right_edge = true


func add_right_wall(cell : Vector2i):
	if tile_above_exists(cell):
		return
	if get_cell_source_id(LAYER, Vector2i(cell.x + 1, cell.y - 1)) != -1: 
		var tile_above = Vector2i(cell.x, cell.y - 1)
		var cell_id = tile_is_in_graph(tile_above)
		

		if cell_id == -1:
			cell_id = astar.get_available_point_id()
			var info = Tile_data.new(cell_id, map_to_local(tile_above))
			info.right_wall = true
			tile_list.append(info)
			astar.add_point(cell_id, map_to_local(tile_above))
		else:
			var f = tile_list.map(func (e): return e.point_id == cell_id)
			tile_list[f.find(true)].right_wall = true

func add_fall_point(cell : Vector2i):
	var fall_tile = find_fall_point(cell)
	if fall_tile == null:
		return
	
	var id = tile_is_in_graph(fall_tile)
	if id == -1:
		id = astar.get_available_point_id()
		var point_info = Tile_data.new(id,map_to_local(fall_tile))
		point_info.fall_point = true
		tile_list.append(point_info)
		astar.add_point(id,map_to_local(fall_tile))
	else:
			var f = tile_list.map(func (e): return e.point_id == id)
			tile_list[f.find(true)].fall_point = true


func find_fall_point(cell : Vector2i):
	var scan = get_start_scan_tile_for_fall_point(cell)
	if scan == null:
		return null
	
	var tile_scan = scan
	var fall_tile = null
	for i in range(500):
		if get_cell_source_id(LAYER,tile_scan+Vector2i.DOWN) != -1:
			return tile_scan
		tile_scan.y += 1
	
	return null


var cells
var astar := AStar2D.new()
const JUMP = 28 #in tiles


func generateGraph() -> void:
	for cell in cells:
		add_left_wall(cell)
		add_right_wall(cell)
		add_left_edge(cell)
		add_right_edge(cell)
		add_fall_point(cell)


func h_connection_possible(p1 : Vector2i,p2 : Vector2i):
	var start_scan = local_to_map(p1)
	var end_scan = local_to_map(p2)
	for i in range (start_scan.x, end_scan.x):
		if get_cell_source_id(LAYER,Vector2i(i,start_scan.y)) != -1 or get_cell_source_id(LAYER,Vector2i(i,start_scan.y + 1)) == -1:
			return false
	return true
		

func connect_h(p : Tile_data):
	if p.left_edge || p.left_wall || p.fall_point:
		var closest = null
		for p2 in tile_list:
			if p.point_id == p2.point_id:
				continue
			if (p2.right_edge || p2.right_wall || p2.fall_point) and p2.position.y == p.position.y and p2.position.x > p.position.x:
				if closest == null:
					closest = Tile_data.new(p2.point_id,p2.position)
				if p2.position.x < closest.position.x:
					closest.position = p2.position
					closest.point_id = p2.point_id
			
		if closest != null:
			if h_connection_possible(p.position,closest.position):
				astar.connect_points(p.point_id,closest.point_id)
				draw_lines_list.append([p.position,closest.position])


func connect_h_platform_j(p1 : Tile_data,p2: Tile_data):
	if p1.point_id == p2.point_id:
		return
	if p1.position.y == p2.position.y and p1.right_edge and p2.left_edge:
		if p2.position.x > p1.position.x:
			if Vector2(local_to_map(p2.position)).distance_to(local_to_map(p1.position)) < JUMP:
				astar.connect_points(p1.point_id,p2.point_id)
				draw_lines_list.append([p1.position,p2.position])
				

func connect_d_j_right_edge(p1 : Tile_data,p2 : Tile_data):
	if p1.right_edge:
		if p2.left_edge and p2.position.x > p1.position.x and p2.position.y > p1.position.y and Vector2(local_to_map(p2.position)).distance_to(local_to_map(p1.position)) < JUMP:
			astar.connect_points(p1.point_id,p2.point_id)
			draw_lines_list.append([p1.position,p2.position])


func connect_d_j_left_edge(p1 :Tile_data,p2 : Tile_data):
	if p1.left_edge and p2.right_edge and p2.position.x < p1.position.x and p2.position.y > p1.position.y and Vector2(local_to_map(p2.position)).distance_to(local_to_map(p1.position)) < JUMP:
		astar.connect_points(p1.point_id,p2.point_id)
		draw_lines_list.append([p1.position,p2.position])

func connect_j(p1 : Tile_data):
	for p2 in tile_list:
		connect_h_platform_j(p1,p2)
		connect_d_j_left_edge(p1,p2)
		connect_d_j_right_edge(p1,p2)
		
		
func connect_f(p1 : Tile_data):
	if p1.left_edge or p1.right_edge:
		var tile_pos = local_to_map(p1.position) + Vector2i.DOWN
		var fall_point = find_fall_point(tile_pos)
		if fall_point == null:
			return
		var point_info = get_point_info(fall_point)
		if Vector2(local_to_map(point_info.position)).distance_to(local_to_map(p1.position)) <= JUMP:
			astar.connect_points(p1.point_id,point_info.point_id)
			draw_lines_list.append([p1.position,point_info.position])
		else:
			astar.connect_points(p1.point_id,point_info.point_id,false)
			draw_lines_list.append([p1.position,point_info.position])

func connect_points():
	for p in tile_list:
		connect_h(p)
		connect_j(p)
		connect_f(p)
		


