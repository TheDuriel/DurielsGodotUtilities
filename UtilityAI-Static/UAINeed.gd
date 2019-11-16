extends Resource
class_name UAINeed
"""
	UAINeed Resource Script
"""
# warning-ignore:unused_class_variable
export(String) var name: String = "testneed"
export(float, 0.0, 100.0) var value: float = 100.0 setget set_value
export(float, 0.0, 1.0) var decay: float = 0.4 setget set_decay
	# Used to model the rate at which the need decays
export(Curve) var decay_curve: Curve = preload("./Curves/Curve-Linear.tres")
	# Used to calculate the impact of a change made to value
# warning-ignore:unused_class_variable
export(Curve) var reward_curve: Curve = preload("./Curves/Curve-Linear.tres")


func set_value(new_value: float) -> void:
	value = clamp(new_value, 0.0, 100.0)


func set_decay(new_value: float) -> void:
	decay = clamp(new_value, 0.0, 1.0)


func _init() -> void:
	if not is_instance_valid(decay_curve):
		Log.error(self, "_init: decay_curve missing.")


func advance(delta: float) -> void:
	value -= decay * decay_curve.interpolate_baked(clamp(value, 0.0, 0.99)) * delta
