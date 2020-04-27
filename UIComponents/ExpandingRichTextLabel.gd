tool
extends RichTextLabel
class_name ExpandingRichTextLabel

var _previous_size: int = 0


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var new_size: int = int(ceil(get_v_scroll().max_value))
	if not _previous_size == new_size:
		rect_size.y = new_size
		rect_min_size.y = new_size
		_previous_size = new_size
