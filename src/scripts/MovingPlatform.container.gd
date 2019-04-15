tool
extends Node2D
class_name MovingPlatformContainer
const class_type : String = "MovingPlatformContainer"

export (float, 10, 100) var MOVEMENT_SPEED : float = 40.0
export var ONE_WAY_COLLISION : bool = true setget __set_one_way_collision
export (int, 2, 8) var TILE_WIDTH : int = 2 setget __set_tile_width
export var COLOR : Color = "#FFFFFF" setget __set_color

func _ready() -> void:
	$MovingPlatformPoint0.set_as_zero()
	update_points()

func update_points() -> void:
	for point in get_points():
		point.update_all(self)
func get_points() -> Array:
	var points : Array = Utils.get_node_children_by_class_type(self, MovingPlatformPoint.class_type)
	return Utils.sort_nodes_by_order_number(points)

func get_points_positions() -> Array:
	var positions : Array = Array()
	for point in get_points():
		positions.append(point.position)
	return positions
		
func clear_points() -> void:
	var points : Array = Utils.get_node_children_by_class_type(self, MovingPlatformPoint.class_type)
	for point in points:
		point.queue_free()



func __set_one_way_collision(value : bool) -> void:
	ONE_WAY_COLLISION = value
	print(value)
	update_points()

func __set_tile_width(value : int) -> void:
	TILE_WIDTH = value
	update_points()

func __set_color(value : Color) -> void:
	COLOR = value
	update_points()