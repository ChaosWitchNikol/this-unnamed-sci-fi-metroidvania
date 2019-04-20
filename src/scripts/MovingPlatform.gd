extends KinematicBody2D
class_name MovingPlatform
const class_type : String = "MovingPlatform"

var points : Array = Array()
var target_point_index : int = 0
var move_speed : float = 0

var direction : Vector2 = Vector2()

var min_distance_reached := true

func _ready():
	next_target_point()
	min_distance_reached = false

func setup(points : Array, width : int, movement_speed : float, one_way_collision : bool = true) -> void:
	self.points = points
	move_speed = movement_speed
	setup_collision(width, one_way_collision)
	setup_tilemap(width, one_way_collision)
	position = self.points[target_point_index]

func _physics_process(delta) -> void:
	if points.size() > 1:
		position += direction * move_speed * delta
			
		if not min_distance_reached:
			if position.distance_to(points[target_point_index]) < 1:
				min_distance_reached = true
		else:
			if position.distance_to(points[target_point_index]) > 1:
				next_target_point()
				min_distance_reached = false


func next_target_point():
	target_point_index += 1
	if target_point_index > points.size() - 1:
		target_point_index = 0
	direction = (points[target_point_index] - position).normalized()


func setup_collision(width : int, one_way_collision : bool) -> void:
	# first set new extent size
	$Collision.shape.extents.x = width * Const.TILE_HALF_SIZE
	# this will make collsion shape unique for each platfor
	# because collision shapes seems to be shared across all same nodes
	$Collision.shape = $Collision.shape.duplicate()
	# second set one way collision	
	$Collision.set_one_way_collision(one_way_collision)

func setup_tilemap(width : int, one_way_collision : bool) -> void:
	$Tiles.clear()
	$Tiles.position.x = - width * Const.TILE_HALF_SIZE
	var tile_offset = 3
	if one_way_collision:
		tile_offset = 0
	
	#	set left edge tile
	$Tiles.set_cell(0, 0, tile_offset)
	#	set right edge tile
	$Tiles.set_cell(width - 1, 0, tile_offset, true)
	
	#	set middle tiles
	if width > 2:
		for index in range(1, width - 1):
			$Tiles.set_cell(index, 0, tile_offset + 1)


