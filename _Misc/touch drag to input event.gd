var last_motion = Vector2()


func _input(event):
	if event is InputEventSreenDrag:
		var dir = null
		if relative.y < last_motion:
			dir = "move_up"
		elif relative.y > last_motion:
			dir = "move_down"
		# do for left right
		
		if not dir == null:
			get_tree().set_input_as_handled()
			var new_action = InputEventAction.new()
			new_action.action = dir
			Input.parse_input_event(new_action)