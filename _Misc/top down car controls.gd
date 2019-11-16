extends RigidBody2D

const SPIN_SPEED = deg2rad(5) # speed at which you turn in degrees
const ACCELLERATION = 5 # rate at which you accelerate/decellerate
const MAX_SPEED = 300 # maximum forward speed
const MIN_SPEED = -100 # maximum backward speed
const SPRITE_SPIN_OFFSET = deg2rad(-90) 
var speed = 0
var spin = 0


func _integrate_forces(state):
	
	if Input.is_action_pressed("ui_up"):
		speed += ACCELLERATION
	if Input.is_action_pressed("ui_down"):
		speed -= ACCELLERATION
	
	if Input.is_action_pressed("ui_left"):
		spin -= SPIN_SPEED
	if Input.is_action_pressed("ui_right"):
		spin += SPIN_SPEED
	
	speed = clamp(speed, MIN_SPEED, MAX_SPEED)
	var velocity = Vector2(0, 1).rotated(spin)
	state.linear_velocity = velocity * speed
	
	$player1.rotation = spin + SPRITE_SPIN_OFFSET