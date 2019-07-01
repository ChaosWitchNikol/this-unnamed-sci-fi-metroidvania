extends Enemy
class_name EnemyCrawlingNew2

const ROT_INNER : int = -1
const ROT_OUTER : int = 1

var forward_vector : Vector2


func _ready() -> void:
	calc_forward_vector()

################################
#	Custom functions
#	processors
## @Override
func process_movement(delta : float) -> void:
	var collides : Array = [is_on_floor(), is_on_wall(), is_on_ceiling()]
	var collides_count : int = collides.count(true)
	$Body2.disabled = $GroundMid.is_colliding()
	
	var grounds : Array = [$GroundBack.is_colliding(), $GroundMid.is_colliding(), $GroundFront.is_colliding()]
	var grounds_count : int = grounds.count(true)
	
	if collides_count == 1:
		if grounds_count == 0:
			process_rotation(ROT_OUTER)
			return
	elif collides_count > 1:
		if not $Back.is_colliding():
			process_rotation(ROT_INNER)
		
			return
#	print($Back.is_colliding())
	if $Back.is_colliding() or grounds_count >= 1:
		process_forward()
		print("move forward ")
		

func process_rotation(rotation_type : int ) -> void:
	linear_velocity = Vector2()
	position = position.round()
	
	var test_rotation_degrees : float = round(rotation_degrees + 90 * rotation_type)
	if test_rotation_degrees < 0:
		test_rotation_degrees = round(360.0 + test_rotation_degrees)
	elif test_rotation_degrees > 360:
		test_rotation_degrees = round(test_rotation_degrees - 360.0)
	
#	if test_move(Transform2D(test_rotation_degrees, position), position):
	rotation_degrees = test_rotation_degrees
	calc_next_gravity_and_forward_vector(rotation_type)

func process_forward() -> void:
	if abs(forward_vector.x) > 0:
		linear_velocity.x = MOVEMENT_SPEED * forward_vector.x
	if abs(forward_vector.y) > 0:
		linear_velocity.y = MOVEMENT_SPEED * forward_vector.y

func calc_next_gravity_and_forward_vector(rotation_type : int) -> void:
	forward_vector = gravity_vector * rotation_type
	gravity_vector = gravity_vector.rotated(PI / 2 * facing * rotation_type).round()


func calc_forward_vector() -> void:
	forward_vector = gravity_vector.rotated(-PI / 2 * facing).round()

################################
#	Setters
## @Override
func set_facing(value: int = FacingDirs.RIGHT) -> void:
	.set_facing(value)
	if get_node("Body2"):
		$Body2.position.x = abs($Body2.position.x) * -value



