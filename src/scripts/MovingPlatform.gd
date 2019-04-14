tool
extends Node2D

const PointScene : PackedScene = preload("res://scenes/MovingPlatformPoint.tscn")

onready var Tiles : TileMap = get_node("Body/Tiles")

#	export variables
export var MOVEMENT_SPEED : float = 40.0
export var ONE_WAY_COLLISION : bool = false setget __set_one_way_collision
export (int, 2, 16) var SIZE_X : int = 4 setget __set_size_x

#	point variables
var all_points : Array
var current_point_index : int = 0
var next_point_index : int = 1

#	lifetime variables
var direction : Vector2 = Vector2()

func _ready() -> void:
	# create starting point
	var point = PointScene.instance()
	point.set_as_start()
	add_child(point)
	
	# get all points and sort them by order number
	all_points = Utils.get_node_children_by_type(self, "Position2D")
	all_points = Utils.sort_nodes_by_order_number(all_points)
	
	# set statrting moving direction
	set_direction_vector()
	
	#	set tiles
	set_tiles()



func get_next_point_position() -> Vector2:
	return all_points[next_point_index].position

func set_direction_vector():
	direction = all_points[next_point_index].global_position - all_points[current_point_index].global_position 
	direction = direction.normalized()

func set_next_target_point():
	current_point_index += 1
	if current_point_index >= all_points.size():
		current_point_index = 0
	
	next_point_index = current_point_index + 1
	if next_point_index >= all_points.size():
		next_point_index = 0


func set_tiles() -> void:
	var tiles : TileMap = get_node("Body/Tiles")
	tiles.size_x = SIZE_X * Const.TILE_SIZE
	tiles.one_way = ONE_WAY_COLLISION

func __set_one_way_collision(value : bool) -> void:
	ONE_WAY_COLLISION = value
	set_tiles()
func __set_size_x(value : int) -> void:
	SIZE_X = value
	set_tiles()
	



