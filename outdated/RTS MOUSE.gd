extends ScrollContainer

var active = false


func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_RIGHT:
            if event.pressed:
                active = true
            else:
                active = false
            accept_event()
    
    if event is InputEventMouseMotion and active:
        scroll_horizontal = event.relative.x * 1
        scroll_vertical = event.relative.y * 1
        accept_event()