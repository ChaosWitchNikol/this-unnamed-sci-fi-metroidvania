extends Enemy
class_name EnemyCrawlingNew2

onready var FeelFront : RayCast2D = get_node("FeelFront")


const ROT_INNER : int = -1
const ROT_OUTER : int = 1



var forward_vector : Vector2


func _ready() -> void:
	calc_forward_vector()
	FeelFront.cast_to.x *= facing

################################
#	Custom functions
#	processors
## @Override
func process_movement(delta : float) -> void:
	var collides : Array = [is_on_floor(), is_on_wall()]
	var collides_count : int = collides.count(true)
	$Body2.disabled = $GroundMid.is_colliding()
	
	var grounds : Array = [$GroundBack.is_colliding(), $GroundMid.is_colliding(), $GroundFront.is_colliding()]
	var grounds_count : int = grounds.count(true)
	
	if grounds_count == 0 and $FeelFront.is_colliding():
		self.flip_facing()
	
	if is_on_floor():
		if grounds_count == 0:
			process_rotation(ROT_OUTER)
			return
	
	if $FeelFront.is_colliding():
		process_rotation(ROT_INNER)
		return

	if grounds_count >= 1:
		process_forward()
		

func process_rotation(rotation_type : int ) -> void:
	linear_velocity = Vector2()
	position = position.round()
	
	var test_rotation_degrees : float = round(rotation_degrees + (90 * facing) * rotation_type)
	if test_rotation_degrees < 0:
		test_rotation_degrees = round(360.0 + test_rotation_degrees)
	elif test_rotation_degrees > 360:
		test_rotation_degrees = round(test_rotation_degrees - 360.0)
	
	print(test_move(Transform2D(test_rotation_degrees, position), gravity_vector, false))
	
	if test_move(Transform2D(test_rotation_degrees, position), position):
		position += gravity_vector
		rotation_degrees = test_rotation_degrees
		calc_next_gravity_and_forward_vector(rotation_type)

func process_forward() -> void:
	if abs(forward_vector.x) > 0:
		linear_velocity.x = MOVEMENT_SPEED * forward_vector.x
	if abs(forward_vector.y) > 0:
		linear_velocity.y = MOVEMENT_SPEED * forward_vector.y

func calc_next_gravity_and_forward_vector(rotation_type : int) -> void:
	forward_vector = gravity_vector * rotation_type
	self.gravity_vector = gravity_vector.rotated(PI / 2 * facing * rotation_type).round()


func calc_forward_vector() -> void:
	forward_vector = gravity_vector.rotated(-PI / 2 * facing).round()


#	life
##	@Override
func flip_facing() -> void:
	.flip_facing()
	calc_forward_vector()
	FeelFront.position.x = abs(FeelFront.position.x) * facing
	FeelFront.cast_to.x = abs(FeelFront.cast_to.x) * facing

################################
#	Setters
## @Override
func set_facing(value: int = FacingDirs.RIGHT) -> void:
	.set_facing(value)
	if get_node("Body2"):
		$Body2.position.x = abs($Body2.position.x) * -value



