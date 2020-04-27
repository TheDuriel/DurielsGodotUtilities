tool
extends Position2D
class_name AAStar2DTestAgent
"""
	AAStar2DTestAgent
	
	Simple Test agent for in editor debugging.
"""

const MANAGER_GROUP_NAME: String = "aastar2dmanager"

onready var _manager #: AAStar2DManager

var _path: Array = []


func _draw() -> void:
	draw_circle(Vector2.ZERO, 16.0, Color.blue)


func _ready() -> void:
	set_process(false)
	var marray: Array = get_tree().get_nodes_in_group(MANAGER_GROUP_NAME)
	if marray.empty():
		print("Warning: AAStar2DTestAgent: _ready(): No AAStar2DManager found!")
		return
	
	_manager = marray[0]
	
	set_process(true)


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	if not _path.empty():
		global_position = lerp(global_position, _path[0], 0.1)
		if global_position.distance_to(_path[0]) < 2.0:
			_path.pop_front()
	else:
		if _manager:
			_path = _manager.get_path_from_to(global_position, get_global_mouse_position())
