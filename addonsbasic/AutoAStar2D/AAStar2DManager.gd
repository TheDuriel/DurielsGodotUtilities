tool
extends Node
class_name AAStar2DManager
"""
	AAStar2DManager Class Script
	
	Only the first instance of AAStar2DManager will be used
	
	License: MIT. Written by Manuel 'TheDuriel' Fischer
	
	Collects AAStar2DPoints underneath it to create an A* Grid
	Use 'get_path_from_to()'' with global positions to get a path
	Use 'frozen' to stop the Manager from rebuilding the network upon changes
	It may take up to two Frames for the grid to generate the first time around
	It is recommend you increase the size of the message queue when dealing with
	large ammounts of points
	
	Future Plans:
		Let AAStar2DPoints track their own neighbors instead of using a Struct.
		Optimize tracking of neighbors to reduce _update_grid() for loop size.
		Spatial Version. (global_position = global_transform.origin, AStar2D = AStar)
"""
signal updated

	# If false _update_grid() will be called during _process() if _update_pending is true
export(bool) var frozen: bool = true
	# Nodes closer to each other than this will not connect.
export(float, 8.0, 512.0) var minimum_distance: float = 64.0 setget set_minimum_distance
	# Nodes further appart than this will not connect.
export(float, 16.0, 2048.0) var maximum_distance: float = 512.0 setget set_maximum_distance
	# Visually draw the network
export(bool) var debug_draw: bool = false setget set_debug_draw

const MANAGER_GROUP_NAME: String = "aastar2dmanager"
const POINT_GROUP_NAME: String = "aastar2dpoint"

var _astar: AStar2D = AStar2D.new()
var _data_by_id: Dictionary = {} # "id" : PointData
var _update_pending: bool = false


func set_minimum_distance(new_value: float) -> void:
	minimum_distance = new_value
	_update_pending = true


func set_maximum_distance(new_value: float) -> void:
	maximum_distance = new_value
	_update_pending = true


func set_debug_draw(new_value: bool) -> void:
	debug_draw = new_value
	if is_inside_tree():
		get_tree().call_group(POINT_GROUP_NAME, "redraw")


func _init() -> void:
	add_to_group(MANAGER_GROUP_NAME)
	#set_meta("_edit_lock_", true)


	# FUNFACT: This is called last during a frame.
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if frozen:
		return
	if _update_pending:
		_update_grid()


	# Immediately recompute the grid. May take some time.
func force_update() -> void:
	if _update_pending:
		_update_grid()


func update_required() -> bool:
	return _update_pending


	# Automatically called by Points during their _ready function.
	# If the Manager was instanced after a Point was created
	# The point must be manually added using this function.
func register_point(point: AAStar2DPoint, position: Vector2, weight: float = 1.0, disabled: bool = false) -> int:
	var id: int = _astar.get_available_point_id()
	var data: PointData = PointData.new(id, point, position)
	_data_by_id[id] = data
	_astar.add_point(id, position, weight)
	_astar.set_point_disabled(id, disabled)
	return id


	# Returns the global_position of a point
func get_point_position(id: int) -> Vector2:
	if _data_by_id.has(id):
		return _data_by_id[id].node.global_position
	else:
		return Vector2.ZERO


	# Returns an Array containing all Points a specific point is connected to.
func get_point_neighbors(id: int) -> Array:
	if _data_by_id.has(id):
		return _data_by_id[id].neighbors
	else:
		return []


	# As get_point_neighbors() but returns global_positions instead.
func get_point_neighbor_positions(id: int) -> Array:
	var n: Array = get_point_neighbors(id)
	var b: Array = []
	for id in n:
		b.append(get_point_position(id))
	return b


	# Automatically called by Points. Sets the position within the grid.
func set_point_position(id: int, position: Vector2) -> void:
	_astar.set_point_position(id, position)
	_data_by_id[id].position = position
	_update_pending = true


	# Automatically called by Points. Sets the weight within the grid.
func set_point_weight(id: int, weight: float) -> void:
	_astar.set_point_weight_scale(id, weight)


	# Automatically called by Points.
func set_point_disabled(id: int, disabled: bool) -> void:
	_astar.set_point_disabled(id, disabled)


func is_point_disabled(id: int) -> bool:
	return _astar.is_point_disabled(id)


	# Automatically called by Points during their _exit_tree() call.
	# Removes a Point from the Grid.
func deregister_point(id: int) -> void:
	# warning-ignore:return_value_discarded
	_data_by_id.erase(id)
	_update_pending = true


	# Returns a path of Point global_positions from A to B
func get_path_from_to(origin: Vector2, target: Vector2) -> PoolVector2Array:
	var o_id: int = _astar.get_closest_point(origin)
	var t_id: int = _astar.get_closest_point(target)
	
	var id_path: PoolIntArray = _astar.get_id_path(o_id, t_id)
	
	var path_positions: PoolVector2Array = PoolVector2Array()
	for id in id_path:
		if _data_by_id.has(id):
			var position: Vector2 = _data_by_id[id].position
			path_positions.append(position)
	
	return path_positions


	# Recomputes the Grid. This may take a while.
func _update_grid() -> void:
	
	_update_pending = false
	
	# Disconnect everything
	for o_id in _data_by_id:
		for t_id in _data_by_id[o_id].neighbors:
			_astar.disconnect_points(o_id, t_id)
			if _data_by_id.has(t_id):
				if _data_by_id[t_id].neighbors.has(o_id):
					_data_by_id[t_id].neighbors.erase(o_id)
					# So we dont disconnect it twice.
	
	# Find Neighbors.
	for o_id in _data_by_id:
		var neighbors: Array = []
		
		var o_position: Vector2 = _data_by_id[o_id].position
		
		for t_id in _data_by_id:
			
			var t_position: Vector2 = _data_by_id[t_id].position
			
			var distance: float = o_position.distance_to(t_position)
			if is_between_inclusive(distance, minimum_distance, maximum_distance):
				neighbors.append(t_id)
		
		_data_by_id[o_id].neighbors = neighbors
	
	# Actually Connect shit.
	for o_id in _data_by_id:
		for t_id in _data_by_id[o_id].neighbors:
			_astar.connect_points(o_id, t_id, true)
	
	if is_inside_tree():
		get_tree().call_group(POINT_GROUP_NAME, "redraw")
	
	emit_signal("updated")


static func is_between_inclusive(value: float, minimum: float, maximum: float) -> bool:
	return value >= minimum and value <= maximum


	# Basically a Struct.
	# Using a Dictionary should have a smaller memory footprint.
	# But lacks static typing.
class PointData:
	extends Reference
	
	var id: int
	var node: AAStar2DPoint
	var position: Vector2
	var neighbors: Array = []
	
	
	func _init(identifier: int, astar_node: AAStar2DPoint, global_position: Vector2):
		id = identifier
		node = astar_node
		position = global_position
