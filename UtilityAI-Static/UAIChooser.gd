extends Reference
class_name UAIChooser
"""
	UAIChooser Class Script
	Picks an UAIAction to execute
"""

func get_next_action(actor: Actor, actions: Array): # Returns UAIAction or null
	# TODO: Return weighed action
	return actions[0] if not actions.empty() else null
