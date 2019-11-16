tool
extends Reference
class_name UAIAction
"""
	UAIAction Resource Script
	Represents an Action
"""
var _owner: Node setget ,get_owner
var _name: String
var _rewards: Dictionary = {} setget ,get_rewards


func get_owner() -> Node:
	return _owner


func get_rewards() -> Dictionary:
	return _rewards.duplicate(true)


func _init(owner: Actor, name: String) -> void:
	_owner = owner
	_name = name


func set_reward(need: String, value: float) -> void:
	_rewards[need] = value


func remove_reward(need: String) -> void:
	if not _rewards.has(need):
		Log.warning(self, "remove_reward: No reward with name %s to remove." % need)
	_rewards.erase(need)
