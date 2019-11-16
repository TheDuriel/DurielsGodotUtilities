extends Reference
class_name UAIRanker
"""
	UAIRanker Class Script
	Ranks UAIActions by Utility
"""


static func rank_actions(actor: Actor, actions: Array) -> Array:
	
	# Wrap actions in dictionary, so we can associate temporary data with it
	var wrapped_actions: Array = []
	for action in actions:
		wrapped_actions.append(
				{
					"action" : action,
					"distance" : -1.0,
					"distance_multiplier" : 0.0,
					"raw_reward_utility" : 0.0,
					"utility_score" : 0.0,
				}
		)
	
	# Add `distance`, and `distance_multiplier`
	_calc_distance_utility(actor, wrapped_actions)
	
	# Add `raw_reward_utility`
	_calc_needs_utility(actor, wrapped_actions)

	# Calculate utility_score
	for action in wrapped_actions:
		action.utility_score = action.raw_reward_utility * action.distance_multiplier
	
	# Sort Actions by Utility Score
	wrapped_actions.sort_custom(UAIRanker, "_sort_actions_by_rank")
	
	# Unwrap
	var ranked_actions: Array = []
	for action in wrapped_actions:
		ranked_actions.append(action.action)
	
	return ranked_actions


static func _calc_distance_utility(actor: Actor, actions: Array) -> void:
	var highest_distance: float = 0.0
	
	# Get raw distances
	for action in actions:
		var distance: float = actor.get_distance_to(action.action.owner)
		
		if distance > highest_distance:
			highest_distance = distance
			
			action.distance = distance
	
	# Calculate utility multiplier
	for action in actions:
		var normalized_distance: float = range_lerp(
				action.distance, 0.0, highest_distance, 0.0, 1.0)
		
		# Smoothstep is used to reduce the difference
		# between the closest and furthest set of actions
		action.distance_multiplier = smoothstep(0.0, 1.0, normalized_distance)


static func _calc_needs_utility(actor: Node, actions: Array) -> void:
	var actor_needs: Dictionary = actor.get_needs()
	
	for action in actions:
		var rewards: Dictionary = action.action.rewards
		
		for need_name in rewards:
			
			if actor_needs.has(need_name):
				action.raw_reward_utility += _calc_need_reward(actor_needs[need_name], rewards[need_name])
			
			else:
				Log.warning(UAIRanker, "calc_needs_utility: need %s not found." % need_name)


static func _calc_need_reward(need: UAINeed, reward: float) -> float:
	return need.reward_curve.interpolate_baked(clamp(need.value + reward, 0.0, 1.0))


static func _sort_actions_by_rank(a: Dictionary, b: Dictionary) -> bool:
	return a.utility_score > b.utility_score
