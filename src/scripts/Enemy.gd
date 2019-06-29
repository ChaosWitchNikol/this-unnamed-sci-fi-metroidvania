extends KinematicBody2D
class_name Enemy

################################
#	Definitions
const MAX_SLOPE_DEGREE : float = deg2rad(50)

################################
#	Nodes variables
onready var Body : CollisionShape2D = get_node("Body")
onready var NextAttackTimeout : Timer = get_node("NextAttackTimeout")
onready var ViewArea : Area2D = get_node("ViewArea")
onready var SpriteNode : Sprite = get_node("Sprite")

onready var ViewAreaShape : CollisionShape2D = get_node("ViewArea/ViewAreaShape")

################################
#	Life variables
export var passive : bool = false 
export var view_distance : float = 8.0 setget set_view_distance
export var view_angle : float = 120.0 setget set_view_angle
var view_half_angle : float = view_angle / 2.0 
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
export var MOVEMENT_SPEED : int = 30

################################
#	Look variables
export(int, -1, 1, 2) var facing : int = FacingDirs.RIGHT setget set_facing

################################
#	Other variables
var linear_velocity : Vector2 = Vector2()
var player_to_follow : Player = null




func _ready() -> void:
	print(">>> enemy ", name, " ready")
	SpriteNode.flip_h = FacingDirs.get_h_flip(facing)
	ViewAreaShape.shape.radius = view_distance
	ViewArea.connect("area_entered", self, "_on_ViewArea_entered")

func _physics_process(delta : float) -> void:
	pre_process(delta)
	process_movement(delta)
	process_gravity(delta)
	
	linear_velocity = move_and_slide_with_snap(linear_velocity, SNAP_VECTOR, FLOOR_VECTOR, true, 5, MAX_SLOPE_DEGREE, false)

################################
#	Custom functions
#	processors
func process_gravity(delta : float) -> void:
	if !apply_gravity:
		return
	linear_velocity += gravity_vector * GRAVITY * MASS * delta 

func process_movement(delta : float) -> void:
	pass

func pre_process(delta : float) -> void:
	pass

#	life
func flip_facing() -> void:
	facing = FacingDirs.flip_h(facing)


################################
#	Setters
func set_gravity_vector(value : Vector2 = Vector2(0, 1)) -> void:
	gravity_vector = value
	FLOOR_VECTOR = value * -1
	SNAP_VECTOR = value * 6

func set_facing(value: int = FacingDirs.RIGHT) -> void:
	facing = value
	if SpriteNode:
		SpriteNode.flip_h = FacingDirs.get_h_flip(facing)

func set_player_to_follow(value : Player) -> void:
	player_to_follow = value

func set_view_distance(value : float = 8.0) -> void:
	view_distance = value

func set_view_angle(value : float = 120.0) -> void:
	view_angle = value
	view_half_angle = value / 2.0

################################
#	Signals
func _on_ViewArea_entered(area : Area2D) -> void:
	if !passive:
		if area.has_method("get_player"):
			call_deferred("set_player_to_follow", area.get_player())
		