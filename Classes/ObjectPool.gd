extends Reference
class_name ObjectPool

var _objects: Array = []
var _available: Array = []
var _used: Array = []

func take_object() -> Object:
	if _available.empty():
		var o: Object = Object.new()
		_objects.append(o)
		_used.append(o)
		return o
	else:
		var o: Object = _available.pop_front()
		_used.append(o)
		return o


func put_object(o: Object) -> void:
	if _objects.has(o):
		_available.append(o)
		_used.erase(o)