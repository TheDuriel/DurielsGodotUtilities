var theta = position.angle_to_point(get_global_mouse_position())
rotation += sin(rotation - theta) * ROTATION_SPEED * delta