extends Enemy
class_name EnemyCrawling

enum SnoutDirs { DOWN = 0, LEFT = 1, UP = 2, RIGHT = 3 }
# Down, Left, Up, Right
const GravityVectors : Array = [Vector2.DOWN, Vector2.LEFT, Vector2.UP, Vector2.RIGHT]

onready var Snout : RayCast2D = get_node("Snout")

################################
#	Life variables
export(float, 4, 32) var snout_length : float = 4 setget set_snout_length

################################
#	Other variables
var crawl_vector : Vector2 = Vector2()
var snout_direction : int = SnoutDirs.DOWN
var motion : Vector2 = Vector2()

var touched_ground : bool = false

func _ready() -> void:
#	_set_snout_facing(facing)
	calc_crawl_vector()

func _physics_process(delta: float) -> void:
	if !touched_ground:
		if Snout.is_colliding():
			touched_ground = true

################################
#	Custom functions
#	processors
##	@Override
func process_movement(delta) -> void:
	process_rotation()
	motion = Vector2()
	motion = crawl_vector * MOVEMENT_SPEED
	if crawl_vector.x != 0:
		linear_velocity.x = motion.x
	if crawl_vector.y != 0:
		linear_velocity.y = motion.y
	pass

func process_rotation() -> void:
	if touched_ground and !Snout.is_colliding():
		snout_direction += facing
		if snout_direction < SnoutDirs.DOWN:
			snout_direction = SnoutDirs.RIGHT
		if snout_direction > SnoutDirs.RIGHT:
			snout_direction = SnoutDirs.DOWN
		self.gravity_vector = GravityVectors[snout_direction]
	pass

#	calculators
func calc_crawl_vector() -> void:
	crawl_vector = gravity_vector.rotated(-facing * deg2rad(90))
	print(crawl_vector)

#	other custom functions


################################
#	Getters
#	Private getters

################################
#	Setters
##	@Override
func set_facing(value : int = FacingDirs.RIGHT) -> void:
	.set_facing(value)
	if Snout:
		_set_snout_facing(value)
	calc_crawl_vector()

##	@Override
func set_gravity_vector(value : Vector2 = Vector2(0, 1)) -> void:
	.set_gravity_vector(value)
	calc_crawl_vector()

func set_snout_length(value : float = 4) -> void:
	snout_length = value
	Snout.cast_to = gravity_vector * snout_length

#	Private setters
func _set_snout_facing(facing : int = FacingDirs.RIGTH) -> void:
	#	this will always flip the snout facing without being child of $Sprite
	Snout.position.x = abs(Snout.position.x) * facing