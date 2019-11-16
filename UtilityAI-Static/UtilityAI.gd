extends Node
class_name UtilityAI
"""
	UtilityAI Utility Class Script
	Root Class of the Utility AI system
	Call get_next_action for the AI to:
		Collect and Rank all advertised actions
		Then choose and return one
"""

static func get_next_action(actor: Node): # Returns UAIAction or null
	if not (actor is Node2D or actor is Spatial):
		Log.error(UtilityAI, "get_next_action: Invalid actor type.")
	
	var advertised_actions: Array = get_advertised_actions(actor.get_tree())
	
	var ranked_actions: Array = UAIRanker.rank_actions(actor, advertised_actions)
	
	var next_action: UAIAction = UAIChooser.choose_action(ranked_actions)
	
	return next_action


static func get_advertised_actions(scene_tree: SceneTree) -> Array:
	var advertisers: Array = scene_tree.get_nodes_in_group("UAIAdvertisers")
	
	var advertised_actions: Array = []
	for advertiser in advertisers:
		advertised_actions += advertiser.get_actions()
	
	return advertised_actions
