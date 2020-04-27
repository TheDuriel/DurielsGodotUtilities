tool
extends Node2D
class_name AAStar2DPoint
"""
	AAStar2DPoint Class Script
	
	Used by AAStar2DManager
	All behavior should be automated
	
	If a AAStar2DManager is meant to be used, but was instanced after a Point
	Call find_manager() to automatically register the point.
	
	Future Plans:
		Error checking.
"""

export(float, 1.0, 10.0) var weight: float = 1.0 setget set_weight
export(bool) var disabled: bool = false setget set_disabled
export(bool) var debug_radius: bool = false setget set_debug_radius

const MANAGER_GROUP_NAME: String = "aastar2dmanager"
const POINT_GROUP_NAME: String = "aastar2dpoint"

onready var _manager #: AAStar2DManager

var _previous_position: Vector2 = Vector2.ZERO
var _id: int
var _neighbor_positions: Array


func set_weight(new_value: float) -> void:
	weight = clamp(new_value, 0.0, 10.0)
	if is_inside_tree() and _manager:
		_manager.set_point_weight(_id, weight)
		update()


func set_disabled(new_value: bool) -> void:
	disabled = new_value
	if is_inside_tree() and _manager:
		_manager.set_point_disabled(_id, disabled)
		update()


func set_debug_radius(new_value: bool) -> void:
	debug_radius = new_value
	update()


func _init() -> void:
	add_to_group(POINT_GROUP_NAME)
	set_process(false)


func _ready() -> void:
	set_process(false)
	find_manager()


func find_manager() -> void:
	var marray: Array = get_tree().get_nodes_in_group(MANAGER_GROUP_NAME)
	if marray.empty():
		print("Warning: AAStar2DPoint: _ready(): No AAStar2DManager found!")
		return
	
	_manager = marray[0]
	_id = _manager.register_point(self, global_position, weight, disabled)
	#_manager.set_point_position(_id, global_position)
	set_process(true)


func _draw() -> void:
	if not _manager or not _manager.debug_draw:
		return
	
	for target_pos in _neighbor_positions:
		target_pos = to_local(target_pos) * 0.5
		var col: Color = Color.red if disabled else _get_weight_color()
		draw_line(Vector2.ZERO, target_pos, col, 1.0, false)
	
	if debug_radius:
		draw_circle(Vector2.ZERO, _manager.minimum_distance, Color(0.0, 0.0, 1.0, 0.1))
		draw_circle(Vector2.ZERO, _manager.maximum_distance, Color(0.0, 1.0, 0.0, 0.1))


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if _manager and not _manager.frozen:
		if global_position.distance_to(_previous_position) > 8.0:
			_manager.set_point_position(_id, global_position)
			_previous_position = global_position


func _exit_tree() -> void:
	if _manager:
		_manager.deregister_point(_id)


func redraw() -> void:
	_neighbor_positions = _manager.get_point_neighbor_positions(_id)
	update()


func _get_weight_color() -> Color:
	var c: Color = Color.green.linear_interpolate(Color.red, (weight - 1.0) / 10.0)
	return c
