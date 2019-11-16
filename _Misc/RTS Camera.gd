extends Camera2D

const SPEED = 200
const MARGIN = 0.20

func _process(delta):
    var velocity = Vector2()
    
    var mpos = get_viewport().get_mouse_position()
    
    var sizex = get_viewport().size.x
    var sizey = get_viewport().size.y

    if mpos.x > sizex * (1 - MARGIN):
        velocity.x = 1
    elif mpos.x < sizex * MARGIN:
        velocity.x = -1
    if mpos.y > sizey * (1 - MARGIN):
        velocity.y = 1
    elif mpos.y < sizey * MARGIN:
        velocity.y = -1
     
    printt(velocity)   
    position += (velocity * SPEED) * delta