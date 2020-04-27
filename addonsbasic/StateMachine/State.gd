extends Reference
class_name State
"""
	State Class Script
	Gains Tree Access through provided Owner.
	i_<name> functions are Interface equivalents.
	Override these when extending this Class.
"""
# warning-ignore:unused_signal
signal state_completed
# warning-ignore:unused_signal
signal state_change_requested(new_state_name)

var _owner: Object


func can_enter(machine, new_owner: Object) -> bool:
	return i_can_enter(machine, new_owner)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func i_can_enter(machine, new_owner: Object) -> bool:
	return true


func enter_state(machine, new_owner: Object) -> void:
	# warning-ignore:return_value_discarded
	connect("state_completed", machine, "_on_current_state_state_completed")
	# warning-ignore:return_value_discarded
	connect("state_change_requested", machine, "_on_current_state_state_change_requested")
	
	_owner = new_owner
	i_enter_state()


	# Called by StateMachine upon Entering this State
func i_enter_state() -> void:
	pass


	# Called each frame by StateMachine
func advance(delta: float) -> void:
	i_advance(delta)


# warning-ignore:unused_argument
func i_advance(delta: float) -> void:
	pass


	# Called each input_event by StateMachine
func input(input_event: InputEvent) -> void:
	i_input(input_event)


# warning-ignore:unused_argument
func i_input(input_event: InputEvent) -> void:
	pass


	# Called by StateMachine upon Exiting this State
func exit_state(machine) -> void:
	disconnect("state_completed", machine, "_on_current_state_state_completed")
	disconnect("state_change_requested", machine, "_on_current_state_state_change_requested")
	i_exit_state()


func i_exit_state() -> void:
	pass
