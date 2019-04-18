tool
extends Node2D
class_name EdiToolMovingPlatformContainer
const class_type : String = "EdiToolMovingPlatformContainer"

const MovingPlatformScene = preload("res://scenes/MovingPlatform.tscn")

export(int, 2, 6) var width : int = 2 setget set_width
export(float, 25.0, 70.0) var movement_speed : float = 40.0
export var color : Color = "#FFFFFF" setget set_color

var points : Array

func set_width(value : int) -> void:
	width = value
	update_points()

func set_color(value : Color) -> void:
	color = value
	update_points()
	update()


func _ready():
	# do only when in editor
	if Engine.editor_hint:
		update_points()
		return
	#	get points into local variable
	#	because queue free probably clears children firs
	points = get_ordered_points_positions()
	queue_free()


func _exit_tree():
	if not Engine.editor_hint:
		setup_platform()

func update_points() -> void:
	for point in get_points():
		point.color = color
		point.width = Const.TILE_SIZE * width

func get_points() -> Array:
	var points : Array = Array()
	for child in get_children():
		if child.get("class_type") == EdiToolMovingPlatformPoint.class_type:
			points.append(child)
	return points

func get_ordered_points_positions() -> Array:
	var positions : Array = Array()
	for point in EdiTools.sort_node_by_order_priority(get_points()):
		positions.append(point.global_position)
	return positions

func _draw() -> void:
	if not Engine.editor_hint:
		return
	draw_rect(Rect2(-16, -16, 32 , 32), color, false)



func setup_platform() -> void:
	if get_parent():
		var inst = MovingPlatformScene.instance()
		inst.position = global_position
		inst.setup(points, width, movement_speed)
		get_parent().call_deferred("add_child", inst)

