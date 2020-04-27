extends KinematicBody2D

onready var animplayer = get_node(#animationplayer)

const SPEED = #speed in pixels per second

var state = Vector2(0, 1)
var animations = {
		Vector2(-1, -1) : ["walk_up_left", "idle_up_left"],
		Vector2(-1, 0) : ["walk_left", "idle_left"],
		Vector2(-1, 1) : ["walk_down_left", "idle_down_left"],
		Vector2(0, -1) : ["walk_up", "idle_up"],
		Vector2(0, 1) : ["walk_down", "idle_down"],
		Vector2(1, -1) : ["walk_up_right", "idle_up_right"],
		Vector2(1, 0) : ["walk_right", "idle_right"],
		Vector2(1, 1) : ["walk_down_right", "idle_down_right"],}


func _physics_process(delta):
	
	# Input
	var velocity = Vector2()
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	# Movement
	move_and_slide(velocity * SPEED)
	
	# Animation
	var animation = animations[state][1]
	if not velocity == Vector2():
		animation = animations[velocity][0]
	
	if animplayer.current_animation != animation:
		animplayer.play(animation)