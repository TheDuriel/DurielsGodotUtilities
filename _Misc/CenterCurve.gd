
func center_my_curve(new_value: bool) -> void:
	if not new_value:
		return
	if not is_instance_valid(curve):
		return
	
	# Get position of all Points in Curve
	var point_count: int = curve.get_point_count()
	
	var points: Array = []
	
	for i in point_count:
		points.append(curve.get_point_position(i))
	
	# Calculate Bounding Box
	var new_bounding_box: Rect2 = Rect2()
	
	for i in points:
		if i.x < bounding_box.position.x:
			bounding_box.position.x = i.x
		elif i.x > bounding_box.size.x:
			bounding_box.size.x = i.x
		
		if i.y < bounding_box.position.y:
			bounding_box.position.y = i.y
		elif i.y > bounding_box.size.y:
			bounding_box.size.y = i.y
	
	# Find Offset
	var center_point: Vector2 = Vector2()
	center_point.x = (bounding_box.size.x / 2) + (bounding_box.position.x / 2)
	center_point.y = (bounding_box.size.y / 2) + (bounding_box.position.y / 2)
	
	# Fix point offset
	var fixed_points: Array = []
	
	for i in points:
		fixed_points.append(i - center_point)
	
	# Apply new Curve
	var new_curve: Curve2D = Curve2D.new()
	for i in fixed_points:
		new_curve.add_point(i)
	
	curve = new_curve
	bounding_box = new_bounding_box
	
	# Pivot if required
	if pivot_on_parent:
		center_on_my_parent()
