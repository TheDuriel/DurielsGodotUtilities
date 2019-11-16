extends Node
class_name UAIAdvertiser
"""
	UAIAdvertiser Class Script
"""

var _actions: Array = [] setget set_actions, get_actions


# warning-ignore:unused_argument
func set_actions(new_value: Array) -> void:
	pass


func get_actions() -> Array:
	# Shallow copy to prevent editing of the array, but not its contents
	return _actions.duplicate(false)


func _init(parent: Actor) -> void:
	add_to_group("UAIAdvertisers")
	parent.call_deferred("add_child", self)


func add_action(action: UAIAction) -> void:
	_actions.append(action)


func remove_action(action: UAIAction) -> void:
	_actions.erase(action)


func is_advertising(action: UAIAction) -> bool:
	return _actions.has(action)
