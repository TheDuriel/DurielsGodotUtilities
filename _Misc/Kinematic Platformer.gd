extends KinematicBody2D

const MAX_HORIZONTAL_SPEED: int = 1200
const MAX_VERTICAL_SPEED: int = 1200
const HORIZONTAL_ACCELERATION_FACTOR: float = 0.1 # Percentage from 0.0 to 1.0
const VERTICAL_ACCELERATION_FACTOR: float = 0.1 # Percentage from 0.0 to 1.0
const GRAVITY: int = 800 # Applied downwards force per second
const JUMP_FORCE: int = 2000 # Power of the jump
const MAX_SLOPE_ANGLE: float = TAU / 8 # Max steepness the character can rest on without sliding. 45° in radians
const MAX_JUMP_ERROR: float = 0.1 # 
const MAX_JUMPS: int = 1 # To allow double, triple, etc. jumps

onready var _anim_player: AnimationPlayer = $"AnimationPlayer"

var _velocity: Vector2 = Vector2()
var _jumps: int = 0 # Number of jumps performed before hitting the floor.
var _air_time: float = 0


func _physics_process(delta: float) -> void:
	
	# The speed we want to move at
	var target_velocity: Vector2 = Vector2()
	
	# Set the Horizontal 'target_velocity'
	if Input.is_action_pressed("move_left"):
		target_velocity.x = -MAX_HORIZONTAL_SPEED
	if Input.is_action_pressed("move_right"):
		target_velocity.x = MAX_HORIZONTAL_SPEED
	
	# Apply gravity, also applies air resistance.
	target_velocity.y = GRAVITY
	
	# Check if we may perform a jump
	if Input.is_action_just_pressed("move_jump"):
		
		var can_jump: bool = false
		
		# Allow jumping if we were on the floor on the previous frame, or we only just recently started falling
		if is_on_floor() or air_time <= MAX_JUMP_ERROR:
			can_jump = true
		
		# Allow double jumping if we're in the air and jumps is below max_jumps
		elif not is_on_floor() and jumps <= MAX_JUMPS:
			can_jump = true
		
		# Apply the jump force
		if can_jump:
			target_velocity.y = -JUMP_FORCE
		
			# Track number of jumps performed
			jumps += 1
	
	# Calculate the new velocity
	_velocity.x = lerp(_velocity.x, target_velocity.x, 0.1)
	_velocity.y = lerp(_velocity.y, target_velocity.y, 0.1)
	
	# Apply motion. Retain remainder
	_velocity = move_and_slide(velocity, Vector2.DOWN, MAX_SLOPE_ANGLE)
	
	# Reset 'jumps' to allow jumping once the character returns to the floor
	if is_on_floor():
		_jumps = 0
	
	# Allow jumping if we only recently started falling
	if not is_on_floor():
		_air_time += delta
	else:
		_air_time = 0.0
	
	# Animation State Machine
	var desired_animation: String = "idle"
	
	if not is_on_floor() and velocity.y < 0.0:
		desired_animation = "jumping"
	
	elif not is_on_floor() and velocity.y >= 0.0:
		desired_animation = "falling"
	
	elif velocity.x < 0.0:
		desired_animation = "walk_left"
	
	elif velocity.x > 0.0:
		desired_animation = "walk_right"
	
	# Play the desired_animation if it is not the current animation
	# Or if the current animation ended and we need to loop it.
	if _anim_player.current_animation != desired_animation:
		_anim_player.play(desired_animation)
