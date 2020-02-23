extends Reference
class_name State
"""
	State Class Script
	Gains Tree Access through provided Owner.
	i_<name> functions are Interface equivalents.
	Override these when extending this Class.
"""
signal state_completed
signal state_change_requested(new_state_name)

var _owner: Object


func can_enter(machine, new_owner: Object) -> bool:
	return i_can_enter(machine, new_owner)


func i_can_enter(machine, new_owner: Object) -> bool:
	return true


func enter_state(machine, new_owner: Object) -> void:
	connect("state_completed", machine, "_on_current_state_state_completed")
	connect("state_change_requested", machine, "_on_current_state_state_change_requested")
	
	_owner = new_owner
	i_enter_state()


	# Called by StateMachine upon Entering this State
func i_enter_state() -> void:
	pass


	# Called each frame by StateMachine
func advance(delta: float) -> void:
	i_advance(delta)


func i_advance(delta: float) -> void:
	pass


	# Called each input_event by StateMachine
func input(input_event: InputEvent) -> void:
	i_input(input_event)


func i_input(input_event: InputEvent) -> void:
	pass


	# Called by StateMachine upon Exiting this State
func exit_state(machine) -> void:
	disconnect("state_completed", machine, "_on_current_state_state_completed")
	disconnect("state_change_requested", machine, "_on_current_state_state_change_requested")
	i_exit_state()


func i_exit_state() -> void:
	pass
