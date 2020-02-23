extends State


	# Called to confirm validity of Entering this State
func i_can_enter(machine: StateMachine, new_owner: Object) -> bool:
	return true


	# Called by StateMachine immediatly after Entering this State.
func i_enter_state() -> void:
	pass


	# Called every Frame by StateMachine
func i_advance(delta: float) -> void:
	pass


	# Called every Input by StateMachine
func i_input(inout_event: InputEvent) -> void:
	pass


	# Called by StateMachine immediatly before Entering this State.
func i_exit_state() -> void:
	pass
