tool
extends EditorPlugin

onready var view: Viewport = get_editor_interface().get_base_control().get_viewport()

var script_editor_button: ToolButton
var freeze_button: CheckBox


func _notification(what) -> void:
	# Enable Drawing on Focus Regain
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		view.render_target_update_mode = Viewport.UPDATE_WHEN_VISIBLE
	# Change to Script Editor on Focus Loss
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		script_editor_button.emit_signal("pressed")
		# Stop Rendering if Freeze Enabled
		if freeze_button.pressed:
			yield(get_tree(), "physics_frame")
			yield(get_tree(), "physics_frame")
			yield(get_tree(), "physics_frame")
			view.render_target_update_mode = Viewport.UPDATE_ONCE


func _enter_tree() -> void:
	# Make Checkbox for Editor Freeze
	freeze_button = CheckBox.new()
	freeze_button.hint_tooltip = "Freeze editor on focus loss."
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, freeze_button)
	freeze_button.get_parent().move_child(freeze_button, 4)
	
	# Get Script Editor Button
	script_editor_button = freeze_button.get_parent().get_child(2).get_child(2)
	
	# Disable Asset Library Button
	freeze_button.get_parent().get_child(2).get_child(3).visible = false
	
	# Force Set Minimum Size to all Docks
	# Not Cleaned Up on Exit
	var nuke := Control.new()
	for i in 8:
		add_control_to_dock(i, nuke)
		nuke.get_parent().rect_min_size = Vector2(256, 256)
		yield(get_tree(), "idle_frame")
		remove_control_from_docks(nuke)
	nuke.queue_free()


func _exit_tree() -> void:
	# Enable Asset Library Button
	freeze_button.get_parent().get_child(2).get_child(3).visible = true
	
	# Delete Things
	freeze_button.queue_free()
	freeze_button = null
