extends Enemy
class_name EnemyCrawling

onready var GroundRayFront : RayCast2D = get_node("GroundRayFront")
onready var GroundRayMid : RayCast2D = get_node("GroundRayMid")
onready var GroundRayBack : RayCast2D = get_node("GroundRayBack")
onready var RotationWaitTimer : Timer = get_node("RotationWaitTimer")

################################
#	Other variables

var do_process_movement : bool = true
var forward_direction_vector : Vector2 = Vector2(1, 0);

func _ready() -> void:
	forward_direction_vector.x *= facing
	GroundRayBack.position.x = -abs(GroundRayBack.position.x) * facing
	GroundRayFront.cast_to.x = abs(GroundRayFront.cast_to.x) * facing
	RotationWaitTimer.connect("timeout", self, "_on_RotationWaitTimer_timeout")


################################
#	Custom functions
#	processors
##	@Override
func process_movement(delta : float) -> void:
	if apply_gravity and is_on_floor():
		apply_gravity = false

	if do_process_movement:
		if !is_colliding() and !is_on_floor():
			# completly stop movement
			linear_velocity = Vector2()
			next_rotation()
			RotationWaitTimer.start()
			do_process_movement = false
			return
		
		linear_velocity = forward_direction_vector * MOVEMENT_SPEED


#	calculators

#	other custom functions
func is_colliding() -> bool:
	return GroundRayBack.is_colliding() or GroundRayMid.is_colliding() or GroundRayFront.is_colliding()


func next_rotation() -> void:
	var add_degrees: float = 90.0
	if is_on_wall():
		add_degrees *= -1
	rotation_degrees = round(rotation_degrees + add_degrees * facing)
	
	if rotation_degrees < 0:
		rotation_degrees += 360
	
	
	print(rotation_degrees)
	
	# rodation degrees to rotation in radians
	var rotation_radians : float = deg2rad(rotation_degrees * facing)
	# calculate forward direction
	forward_direction_vector = Vector2(cos(rotation_radians), sin(rotation_radians))
	print(forward_direction_vector)
	if round(abs(forward_direction_vector.x)) == 0:
		forward_direction_vector.x = 0
	if round(abs(forward_direction_vector.y)) == 0:
		forward_direction_vector.y = 0
	# rotation degrees to rotation in radians offest by -90 degrees 
	# to calculate down
	var rotation_radians_offset : float = deg2rad(rotation_radians - 90.0 )
	self.gravity_vector = Vector2(cos(rotation_radians_offset), sin(rotation_radians_offset))
	



################################
#	Getters
#	Private getters

################################
#	Setters

################################
#	Signals
func _on_RotationWaitTimer_timeout() -> void:
	do_process_movement = true