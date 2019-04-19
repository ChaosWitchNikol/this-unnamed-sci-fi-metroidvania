extends KinematicBody2D

#	DEFINE constants
const FLOOR_VECTOR : Vector2 = Vector2(0, -1)
const SNAP_VECTOR : Vector2 = Vector2(0, 8)
const MAX_SLOPE_DEGREE : float = deg2rad(50)
const JUMP_SNAP_VECTOR : Vector2 = Vector2(0, 0)

#	GET all nodes to variables
onready var nextJumpTimeout = get_node("NextJumpTimeout")

#	DEFINE static variable
export var GRAVITY : float = 9.8
export var MASS : float = 20.0
export var MOVEMENT_SPEED : int = 80
export var JUMP_FORCE : float = 90.0
export var ALLOWED_JUMPS : int = 1
export var NEXT_JUMP_DELAY : int = 100




#	DEFINE lifetime variables
var linear_velocity : Vector2 = Vector2()
var jumps_count : int = 0
var can_jump = true



func _ready():
	#	CONNECT all the signals
	nextJumpTimeout.connect("timeout", self, "_on_NextJumpTimeout_timeout")




func _physics_process(delta : float) -> void:
	#	calculate gravity
	process_gravity(delta)
	#	set snap vector
	var snap_vector : Vector2 = SNAP_VECTOR
	
	
	if is_on_floor():
		linear_velocity.y = 0	# reset y when on the ground
		jumps_count = 0			# reset jump count
	
	if is_on_wall():
		jumps_count = 0			# reset jump count
		if linear_velocity.y > 0:	# when falling / moving downwards
			linear_velocity.y = linear_velocity.y / 1.25	# divide linear velocity by a factor
	
	
	
	if Input.is_action_just_pressed("ui_select"):
		if can_jump and jumps_count < ALLOWED_JUMPS :
			linear_velocity.y = -JUMP_FORCE
			jumps_count += 1
			can_jump = false
			nextJumpTimeout.start(NEXT_JUMP_DELAY / 1000.0)
			snap_vector = JUMP_SNAP_VECTOR
	
	linear_velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		linear_velocity.x = -MOVEMENT_SPEED
	if Input.is_action_pressed("ui_right"):
		linear_velocity.x = MOVEMENT_SPEED
	
	# calculate snap_vector x component based on
	if $RayRight.is_colliding():
		snap_vector.x += 8
	if $RayLeft.is_colliding():
		snap_vector.x -= 8
	
	if is_on_ceiling():
		linear_velocity.y += GRAVITY
		
	linear_velocity = move_and_slide_with_snap(linear_velocity, snap_vector, FLOOR_VECTOR, true, 5, MAX_SLOPE_DEGREE, false)
	
	

func process_gravity(delta : float) -> void:
	linear_velocity.y += GRAVITY * MASS * delta


#	DEFINE singals
func _on_NextJumpTimeout_timeout() -> void:
	can_jump = true