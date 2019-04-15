tool
extends Node2D
class_name MovingPlatformPoint
const class_type : String = "MovingPlatformPoint"

export(int, 1, 10) var ORDER_NUMBER : int = 1 setget __set_order_number

func _ready() -> void:
	if not Engine.editor_hint:
		$Label.visible = false
		$Label.queue_free()
	$Label.text = str(ORDER_NUMBER)

func set_as_zero() -> void:
	ORDER_NUMBER = 0
	$Label.text = "0"
func update_all(parent : Node2D) -> void:
	update()
	modulate = parent.COLOR

func _draw() -> void:
	if not Engine.editor_hint:
		return
	var P  = get_parent()
	if P:
		var top_left : Vector2 = Vector2(-(P.TILE_WIDTH * Const.TILE_HALF_SIZE), 0)
		var top_right : Vector2 = Vector2(P.TILE_WIDTH * Const.TILE_HALF_SIZE, 0)
		var bot_left : Vector2 = Vector2(-(P.TILE_WIDTH * Const.TILE_HALF_SIZE), 8)
		var bot_right : Vector2 = Vector2(P.TILE_WIDTH * Const.TILE_HALF_SIZE, 8)
		
		draw_colored_line(top_left, top_right)
		draw_colored_line(top_left, bot_left, P.ONE_WAY_COLLISION, 0.6)
		draw_colored_line(top_right, bot_right, P.ONE_WAY_COLLISION, 0.6)
		draw_colored_line(bot_left, bot_right, P.ONE_WAY_COLLISION, 0.5)


func draw_colored_line(from : Vector2, to : Vector2, transparent : bool = false, transparency : float = 0.5) -> void:
	var col : Color = "#FFFFFF"
	col.a = 1
	if transparent:
		col.a = transparency
	draw_line(from, to, col, 1.1)


func __set_order_number(value : int) -> void:
	ORDER_NUMBER = value
	$Label.text = str(value)
