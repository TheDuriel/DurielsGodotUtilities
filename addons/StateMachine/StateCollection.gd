extends Reference
class_name StateCollection
"""
	StateCollection Class Script
"""

var _states: Dictionary = {} setget set_states


	# Private variable.
func set_states(new_value: Dictionary) -> void:
	pass


func add_state(state_name: String, state_script: State) -> bool:
	if is_instance_valid(state_script):
		_states[state_name] = state_script
		return true
	
	return false


func get_state(state_name: String) -> State:
	if has_state(state_name):
		return _states[state_name]
	else:
		return State.new()


func remove_state(state_name: String) -> bool:
	if has_state(state_name):
		_states.erase(state_name)
		return true
	
	return false


func has_state(state_name: String) -> bool:
	return _states.has(state_name)


	# Can not be statically typed as it will cause cyclic errors.
func duplicate(): # -> StateCollection:
	var n = get_script().new() # StateCollection = StateCollection.new()
	
	for state_name in _states:
		n.add_state(state_name, _states[state_name])
	
	return n
