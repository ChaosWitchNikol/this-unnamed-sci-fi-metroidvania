extends KinematicBody2D
class_name Enemy

const MAX_SLOPE_DEGREE : float = deg2rad(50)

################################
#	Nodes variables
onready var Body : CollisionShape2D = get_node("Body")
onready var NextAttackTimeout : Timer = get_node("NextAttackTimeout")
onready var ViewArea : Area2D = get_node("ViewArea")

################################
#	Life variables
export var passive : bool = false 
export var view_distance : float = 8.0
export var view_angle : float = 120.0 
export var attack_range : float = 1.0 
export(float, 0.01, 10) var attack_delay : float = 0.01

################################
#	Physics variables
export var apply_gravity : bool = true
export var gravity_vector : Vector2 = Vector2(0, 1) setget set_gravity_vector
var FLOOR_VECTOR : Vector2 = gravity_vector * -1
var SNAP_VECTOR : Vector2 = gravity_vector * 6
export var GRAVITY : float = 9.8
export var MASS : float = 20.0
export var MOVEMENT_SPEED : int = 80


var linear_velocity : Vector2 = Vector2()


func _ready() -> void:
	print(">>> enemy ", name, " ready")

func _physics_process(delta) -> void:
	process_gravity(delta)
	process_movement(delta)
	
	linear_velocity = move_and_slide_with_snap(linear_velocity, SNAP_VECTOR, FLOOR_VECTOR, true, 5, MAX_SLOPE_DEGREE, false)

################################
#	Custom functions
#	processors
func process_gravity(delta) -> void:
	if !apply_gravity:
		return
	linear_velocity += gravity_vector * GRAVITY * MASS * delta 

func process_movement(delta) -> void:
	pass

################################
#	Setters
func set_gravity_vector(value : Vector2 = Vector2(0, 1)) -> void:
	gravity_vector = value
	FLOOR_VECTOR = value * -1
	SNAP_VECTOR = value * 6



