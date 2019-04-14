extends KinematicBody2D

onready var P = get_owner()

func _ready():
	$Collision.shape.extents.x = P.SIZE_X * Const.TILE_HALF_SIZE
	$Collision.shape.extents.y = Const.TILE_HALF_SIZE
	$Collision.one_way_collision = P.ONE_WAY_COLLISION

func _physics_process(delta):
	position += P.direction * P.MOVEMENT_SPEED * delta
	if position.distance_to(P.get_next_point_position()) < 1.0:
		P.set_next_target_point()
		P.set_direction_vector()