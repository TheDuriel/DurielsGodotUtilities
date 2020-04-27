extends Area2D


func _ready():
	set_process_input(false)


func _on_Coin_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			set_process_input(true)

	
func _input(event):
	if event is InputEventMouseButton:
		set_process_input(false)

	elif event is InputEventMouseMotion:
		position += event.relative