extends KinematicBody2D

const FLOOR_VECTOR : Vector2 = Vector2(0, -1)

const GRAVITY : float = 9.8
const MASS : float = 20.0
const MOVEMENT_SPEED : int = 120

const JUMP_FORCE : float = 70.0
const ALLOWED_JUMPS : int = 2



var linear_velocity : Vector2 = Vector2()
var jumps_count : int = 0




func _physics_process(delta : float) -> void:
	
	#	calculate gravity
	linear_velocity.y +=  delta * GRAVITY * MASS
	#	reset y when on the ground
	if is_on_floor():
		linear_velocity.y = 0
		jumps_count = 0
	if is_on_ceiling():
		linear_velocity.y = 0
	if is_on_wall():
		jumps_count = 0
		if linear_velocity.y > 0:
			linear_velocity.y = linear_velocity.y / 2.0
	
	if Input.is_action_just_pressed("ui_select"):
		if jumps_count < ALLOWED_JUMPS:
			linear_velocity.y = -JUMP_FORCE
			jumps_count += 1
		
	
	linear_velocity.x = 0
	if Input.is_action_pressed("ui_left"):
		linear_velocity.x = -MOVEMENT_SPEED
	if Input.is_action_pressed("ui_right"):
		linear_velocity.x = MOVEMENT_SPEED
	
	
	move_and_slide(linear_velocity, FLOOR_VECTOR, true)


