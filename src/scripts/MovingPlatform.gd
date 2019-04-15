extends KinematicBody2D
class_name MovingPlatform

var points : Array = Array()
var target_point_index : int = 0

var direction : Vector2 = Vector2()
var move_speed : float = 0

func _ready() -> void:
	var parent = get_parent()
	if parent and parent.get("class_type") == "MovingPlatformContainer":
		points = parent.get_points_positions()
		parent.clear_points()
		move_speed = parent.MOVEMENT_SPEED
		setup_collision(parent)
		setup_tilemap(parent)
		next_target_point()


func _physics_process(delta) -> void:
	if points.size() > 1:
		position += direction * move_speed * delta
		if position.distance_to(points[target_point_index]) < 0.5:
			next_target_point()


func next_target_point():
	target_point_index += 1
	if target_point_index > points.size() - 1:
		target_point_index = 0
	direction = (points[target_point_index] - position).normalized()


func setup_collision(parent : Node2D) -> void:
	# first set new extent size
	$Collision.shape.extents.x = parent.TILE_WIDTH * Const.TILE_HALF_SIZE
	# second set one way collision
	$Collision.set_one_way_collision(parent.ONE_WAY_COLLISION)

func setup_tilemap(parent : Node2D) -> void:
	$Tiles.clear()
	$Tiles.position.x = - parent.TILE_WIDTH * Const.TILE_HALF_SIZE
	var tile_offset = 3
	if parent.ONE_WAY_COLLISION:
		tile_offset = 0
	var platform_width = parent.TILE_WIDTH * Const.TILE_SIZE
	
	#	set left edge tile
	$Tiles.set_cell(0, 0, tile_offset)
	#	set right edge tile
	$Tiles.set_cell(parent.TILE_WIDTH - 1, 0, tile_offset, true)
	
	#	set middle tiles
	if parent.TILE_WIDTH > 2:
		for index in range(1, parent.TILE_WIDTH - 1):
			$Tiles.set_cell(index, 0, tile_offset + 1)


