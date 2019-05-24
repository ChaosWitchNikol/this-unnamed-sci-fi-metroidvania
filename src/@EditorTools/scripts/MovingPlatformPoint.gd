tool
extends Node2D
class_name EdiToolMovingPlatformPoint
const class_type : String = "EdiToolMovingPlatormPoint"

signal moving_patform_point_tree_changed

export(int , 0, 9) var order_priority : int = 0 setget set_order_priority

var width : int = 16 setget set_width
var height : int = 8 setget set_height
var color : Color = "#FFFFFF" setget set_color

var order_index : int = -1 setget set_order_index

func set_order_priority(value : int) -> void:
	order_priority = value
	$OrderPriorityLabel.text = str(value)
	emit_signal("moving_patform_point_tree_changed")

func set_width(value : int) -> void:
	width = value
	$GrabMask.scale.x = value / 8.0
	update()

func set_height(value : int) -> void:
	height = value
	$GrabMask.scale.y = value / 8.0
	update()

func set_color(value : Color) -> void:
	color = value
	$OrderPriorityLabel.modulate = value
	$OrderIndexLabel.modulate = value
	update()

func set_order_index(value : int) -> void:
	order_index = value
	$OrderIndexLabel.text = str(value)

func _ready() -> void:
	if not Engine.editor_hint:
		return
	
	var parent = get_parent()
	if parent and parent.get("class_type") == "EdiToolMovingPlatformContainer":
		set_width(parent.width * Const.TILE_SIZE)
		set_color(parent.color)
		update()
		
		connect("ready", self, "_on_MovingPlatformPoint_changed")
		connect("tree_entered", self, "_on_MovingPlatformPoint_changed")
		connect("tree_exited", self, "_on_MovingPlatformPoint_changed")
		
		connect("moving_patform_point_tree_changed", parent, "_on_moving_patform_point_changed")
		

func _draw() -> void:
	if not Engine.editor_hint:
		return
	
	#warning-ignore:integer_division
	var half_width = width / 2
	var top_left : Vector2 = Vector2(-half_width, 0)
	var top_right : Vector2 = Vector2(half_width, 0)
	var bot_left : Vector2 = Vector2(-half_width, height)
	var bot_right : Vector2 = Vector2(half_width, height)
	
	draw_line(top_left, top_right, color, 1.001, false)     # top line
	draw_line(top_left, bot_left, color, 1.001, false)      # left line
	draw_line(top_right, bot_right, color, 1.001, false)    # right line
	draw_line(bot_left, bot_right, color, 1.001, false)     # bot line
	





func _on_MovingPlatformPoint_changed():
	emit_signal("moving_patform_point_tree_changed")

