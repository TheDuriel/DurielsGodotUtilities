extends Spatial

	# Alternatively IF you have variable heights in your game
	# Reconstruct the plane every frame using the current height
const FLOOR_HEIGHT: float = 0.0
const INTERSECTION_PLANE: Plane = Plane(Vector3(0, 1, 0,), FLOOR_HEIGHT)

onready var _viewport: Viewport = get_viewport()
onready var _camera: Camera = _viewport.get_camera()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		
		# Get mouse mos on the viewport
		var mouse_pos: Vector2 = _viewport.get_mouse_position()
		# The direction the mouse is pointing at, from the camera
		var mouse_normal: Vector3 = _camera.project_ray_normal(mouse_pos)
		
		# Check if and where the mouse hits our INTERSECTION_PLANE
		var intersection: Vector3 = INTERSECTION_PLANE.intersects_ray(_camera.global_transform.origin, mouse_normal)
		
		# It should always intersect
		if intersection != null:
			
			# You can now feed this intersection to your navigation system
			printt("Floor clicked at: ", intersection)
		