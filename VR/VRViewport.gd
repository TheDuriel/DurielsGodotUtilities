extends Viewport


func _init() -> void:
	size = Vector2(512, 512) # Any ammount is fine.
	#keep_3d_linear = true Seems to just make things worse
	hdr = true


func start_vr() -> void:
	var interface = ARVRServer.find_interface("OpenVR")
	
	if not is_instance_valid(interface):
		push_error("OpenVR interface not found.")
	
	# Configuration
	OS.vsync_enabled = false
	Engine.target_fps = 90 # TODO: Find a way to detect headset and set accordingly.
	ProjectSettings.set_setting("physics/common/physics_fps", 90) #this aint working
	
	var success: bool = interface.initialize()
	if not success:
		push_error("Failed to Initialize OpenVR interface.")
	
	var camera: ARVRCamera = get_tree().get_nodes_in_group("VRCamera")[0]
	VisualServer.viewport_attach_camera(
			get_viewport_rid(), camera.get_camera_rid())
	
	# Finally, Enable VR.
	render_target_update_mode = Viewport.UPDATE_ALWAYS
	arvr = true
	
	# Tell Controllers to initialize
	get_tree().call_group("VRControllers", "_group_initialize_device_id")
