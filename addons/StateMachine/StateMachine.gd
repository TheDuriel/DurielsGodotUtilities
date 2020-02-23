extends Reference
class_name StateMachine
"""
	StateMachine Class Script
"""
var _states: StateCollection = StateCollection.new()

var _owner: Object
var _default_state: State
var _default_state_name: String
var _current_state: State
var _current_state_name: String


func _init(owner: Object, states: StateCollection) -> void:
	_owner = owner
	_states = states.duplicate() # Ensures State Objects are unique to this Machine.


func set_default_state(state_name: String) -> bool:
	if _states.has_state(state_name):
		_default_state = _states.get_state(state_name)
		_default_state_name = state_name
		
		if not _current_state:
			enter_state(_default_state_name)
		
		return true
	
	return false


func try_enter_state(state_name: String) -> bool:
	if _states.has_state(state_name) and _states.get_state(state_name).can_enter(self, _owner):
		enter_state(state_name)
		return true
	return false


func get_default_state_name() -> String:
	return _default_state_name


func get_current_state_name() -> String:
	return _current_state_name


func enter_state(state_name: String) -> void:
	_current_state = _states.get_state(state_name)
	_current_state_name = state_name
	_current_state.enter_state(self, _owner)


func advance_state_delta(delta: float) -> void:
	if _current_state:
		_current_state.advance(delta)


func advance_state_input(input_event: InputEvent) -> void:
	if _current_state:
		_current_state.input(input_event)


	# Exit the Current State without Entering a new State
func exit_state() -> void:
	_current_state = null


func _on_current_state_state_completed() -> void:
	_current_state.exit_state(self)
	exit_state()
	
	if _default_state:
		_current_state = _default_state
