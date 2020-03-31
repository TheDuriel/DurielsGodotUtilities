tool
extends Spatial
class_name VRUIDisplay
"""
	VRUIDisplay Class Script
	Displays a Control Node based UI on a Plane in 3D Space
"""

export(PackedScene) var ui_scene_resource: PackedScene setget set_ui_scene_resource
export(Vector2) var viewport_resolution: Vector2 = Vector2(800, 800) setget set_viewport_resolution
export(float) var pixel_size: float = 1.0 setget set_pixel_size
export(bool) var transparent_bg: bool = false setget set_transparent_bg
# Viewport texture is automatically assigned to Albedo.
export(SpatialMaterial) var display_material: SpatialMaterial = SpatialMaterial.new()

var ui_scene_instance: Control # Publicly expose the UI instance.

var _viewport: Viewport = Viewport.new()
var _mesh_instance: MeshInstance = MeshInstance.new()
var _mesh_plane: PlaneMesh = PlaneMesh.new()
var _area_instance: Area = Area.new()
var _area_shape_instance: CollisionShape = CollisionShape.new()
var _shape_shape: BoxShape = BoxShape.new()


func set_ui_scene_resource(new_value: PackedScene) -> void:
	ui_scene_resource = new_value
	
	if not ui_scene_instance:
		return
	
	if is_instance_valid(ui_scene_instance):
		ui_scene_instance.queue_free()
	
	if is_instance_valid(_viewport):
		ui_scene_instance = ui_scene_resource.instance()
		_viewport.add_child(ui_scene_instance)


func set_viewport_resolution(new_value: Vector2) -> void:
	viewport_resolution = new_value.snapped(Vector2(1, 1))
	if is_instance_valid(_viewport):
		_viewport.size = viewport_resolution
		_update_plane_size()


func set_pixel_size(new_value: float) -> void:
	pixel_size = new_value
	_update_plane_size()


func set_transparent_bg(new_value: bool) -> void:
	transparent_bg = new_value
	if is_instance_valid(_viewport):
		display_material.flags_transparent = transparent_bg
		_viewport.transparent_bg = transparent_bg


func _ready() -> void:
	add_child(_mesh_instance)
	add_child(_viewport)
	add_child(_area_instance)
	_area_instance.add_child(_area_shape_instance)
	_area_shape_instance.shape = _shape_shape
	
	_area_instance.collision_layer = 524288 # LAYER 20
	_area_instance.monitorable = true
	_area_instance.monitoring = false
	
	_mesh_instance.mesh = _mesh_plane
	
	# Assign mesh and copy of the material
	display_material = display_material.duplicate()
	display_material.albedo_texture = _viewport.get_texture()
	display_material.flags_transparent = transparent_bg
	_mesh_instance.material_override = display_material
	
	# Configure the Viewport
	_viewport.size = viewport_resolution
	_viewport.transparent_bg = transparent_bg
	_viewport.render_target_v_flip = true
	
	# Update the DisplayPlane
	_update_plane_size()
	
	# Instance the UI
	if ui_scene_resource:
		ui_scene_instance = ui_scene_resource.instance()
		_viewport.add_child(ui_scene_instance)


func _update_plane_size() -> void:
	_mesh_plane.size = viewport_resolution * (pixel_size * 0.01)
	_shape_shape.extents = Vector3(
			viewport_resolution.x * (pixel_size * 0.01) * 0.5,
			0.01,
			viewport_resolution.y * (pixel_size * 0.01 * 0.5)
			)
