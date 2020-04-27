tool
extends Spatial
class_name VRMousePointer
"""
	VRMousePointer Class Script
	A Ray which generates Mouse Input Events in Screen Space
	Combine with VRUIDisplay to use UI in 3D (UNTESTED)
"""

export(float, 0.5, 20.0) var length = 2.0 setget set_length
export(SpatialMaterial) var material: SpatialMaterial = SpatialMaterial.new()

onready var _viewport: Viewport = get_viewport()
onready var _camera: Camera = _viewport.get_camera()

var _ray: RayCast = RayCast.new()
var _visual_ray_instance: MeshInstance = MeshInstance.new()
var _visual_ray_mesh: CylinderMesh = CylinderMesh.new()

var _canvas_point: Vector2 = Vector2()
var _prev_canvas_point: Vector2 = Vector2()


func set_length(new_value: float) -> void:
	length = clamp(new_value, 0.5, 20.0)
	_update_ray()


func _ready() -> void:
	add_child(_ray)
	_ray.enabled = true
	_ray.collide_with_areas = true
	_ray.collide_with_bodies = false
	_ray.collision_mask = 524288 # LAYER 20
	
	add_child(_visual_ray_instance)
	_visual_ray_instance.mesh = _visual_ray_mesh
	
	_visual_ray_mesh.top_radius = 0.1
	_visual_ray_mesh.bottom_radius = 0.1
	_visual_ray_mesh.radial_segments = 4
	
	_update_ray()


func _unhandled_input(event: InputEvent) -> void:
	if not _ray.is_colliding():
		return
	
	if event.is_action_pressed("virtual_mouse_left"):
		var e: InputEventMouseButton = InputEventMouseButton.new()
		e.position = _canvas_point
		e.pressed = true
		e.button_index = BUTTON_LEFT
		Input.parse_input_event(e)
	
	elif event.is_action_released("virtual_mouse_left"):
		var e: InputEventMouseButton = InputEventMouseButton.new()
		e.position = _canvas_point
		e.pressed = false
		e.button_index = BUTTON_LEFT
		Input.parse_input_event(e)
	
	elif event.is_action_pressed("virtual_mouse_right"):
		var e: InputEventMouseButton = InputEventMouseButton.new()
		e.position = _canvas_point
		e.pressed = true
		e.button_index = BUTTON_RIGHT
		Input.parse_input_event(e)
	
	elif event.is_action_released("virtual_mouse_right"):
		var e: InputEventMouseButton = InputEventMouseButton.new()
		e.position = _canvas_point
		e.pressed = false
		e.button_index = BUTTON_LEFT
		Input.parse_input_event(e)


func _physics_process(delta: float) -> void:
	if _ray.is_colliding():
		var col_point: Vector3 = _ray.get_collision_point()
		_canvas_point = _camera.unproject_position(col_point)
		var e: InputEventMouseMotion = InputEventMouseMotion.new()
		e.position = _canvas_point
		e.speed = _canvas_point - _prev_canvas_point
		_prev_canvas_point = _canvas_point
		Input.parse_input_event(e)


func _update_ray() -> void:
	_ray.cast_to = Vector3(0, length, 0)
	_visual_ray_mesh.height = length
	_visual_ray_instance.transform.origin.y = length * 0.5

