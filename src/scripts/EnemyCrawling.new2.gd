extends Enemy
class_name EnemyCrawlingNew2

#export var(float, 0, 360, 90) 

var forward_vector : Vector2


func _ready() -> void:
	calc_forward_vector()
################################
#	Custom functions
#	processors
## @Override
func process_movement(delta : float) -> void:
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		if $Face.is_colliding():
			print("face collidign")
		$Body2.disabled = $GroundMid.is_colliding()
		if $GroundBack.is_colliding() or $GroundMid.is_colliding() or $GroundFront.is_colliding():
			if abs(forward_vector.x) > 0:
				linear_velocity.x = MOVEMENT_SPEED * forward_vector.x
			elif abs(forward_vector.y) > 0:
				linear_velocity.y = MOVEMENT_SPEED * forward_vector.y
		else:
			linear_velocity = Vector2()
			position = position.round()
			var rot : float = rotation_degrees
			var test_rotation : float = round(rotation_degrees + 90)
			
			if test_rotation < 0:
				test_rotation = round(360.0 + test_rotation)
			
			var test = test_move(Transform2D(test_rotation, position), position)
			if test:
				rotation_degrees = test_rotation
				gravity_vector = gravity_vector.rotated(PI / 2 * facing).round()
				calc_forward_vector()


func calc_forward_vector() -> void:
	forward_vector = gravity_vector.rotated(-PI / 2 * facing).round()

################################
#	Setters
## @Override
func set_facing(value: int = FacingDirs.RIGHT) -> void:
	.set_facing(value)
	if get_node("Body2"):
		$Body2.position.x = abs($Body2.position.x) * -value



