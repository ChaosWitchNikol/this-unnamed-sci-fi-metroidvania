tool
extends Node2D
class_name EdiToolMovingPlatformContainer
const class_type : String = "EdiToolMovingPlatformContainer"


const MovingPlatformScene = preload("res://scenes/MovingPlatform.tscn")

export(int, 2, 6) var width : int = 2 setget set_width
export(float, 25.0, 70.0) var movement_speed : float = 40.0
export var color : Color = "#FFFFFF" setget set_color

var points : Array

var children_string : String = ""

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
		update_points_indexes()
		return
	#	get points into local variable
	#	because queue free probably clears children firs
	points = get_ordered_points_positions()
	queue_free()


func _exit_tree():
	if not Engine.editor_hint:
		setup_platform()
		

func _physics_process(delta) -> void:
	if not Engine.editor_hint:
		return

func update_points() -> void:
	for point in get_points():
		point.color = color
		point.width = Const.TILE_SIZE * width

func update_points_indexes() -> void:
	var index = 0
	for point in EdiTools.sort_node_by_order_priority(get_points()):
		point.order_index = index
		index += 1

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
	
	var sc : Sprite = get_node("InvisibleSpriteMask").scale
	
	var col : Color = color
	col.a = 0.6
	
	var half = Const.TILE_HALF_SIZE
	var size = Const.TILE_SIZE
	
	var top_left := Vector2(-sc.x * half, -sc.y * half)
	var top_right := Vector2(sc.x * half, -sc.y * half)
	var bot_left := Vector2(-sc.x * half, sc.y * half)
	var bot_right := Vector2(sc.x * half, sc.y * half)

	var horizontal := Vector2(size, 0)
	var vertical := Vector2(0, size)

	#	left top corner
	draw_line(top_left, top_left + horizontal, col, 1.001)
	draw_line(top_left, top_left + vertical, col, 1.001)
	
	#	right top corner
	draw_line(top_right, top_right - horizontal, col, 1.001)
	draw_line(top_right, top_right + vertical, col, 1.001)
	
	#	left bottom corner
	draw_line(bot_left, bot_left + horizontal, col, 1.001)
	draw_line(bot_left, bot_left - vertical, col, 1.001)
	
	#	right bottom corner
	draw_line(bot_right, bot_right - horizontal, col, 1.001)
	draw_line(bot_right, bot_right - vertical, col, 1.001)
		
	



func setup_platform() -> void:
	if get_parent():
		var inst = MovingPlatformScene.instance()
		inst.position = global_position
		inst.setup(points, width, movement_speed)
		get_parent().call_deferred("add_child", inst)



func _on_moving_patform_point_changed() -> void:
	update_points_indexes()

