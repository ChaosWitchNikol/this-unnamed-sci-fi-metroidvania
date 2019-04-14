tool
extends Position2D
class_name MovingPlatformPoint

export var ORDER_NUMBER : int = 1 setget _set_order_number
export var COLOR : Color = "#FFFFFF" setget _set_color
export var VISIBLE_FOR_DEBUG : bool = false

onready var NumberLabel : Label = get_node("Label")

func _set_order_number(value : int) -> void:
	if value > 0:
		ORDER_NUMBER = value
		update()
		if NumberLabel:
			NumberLabel.text = str(value)

func _set_color(value : Color) -> void:
	COLOR = value
	update()
	if NumberLabel:
		NumberLabel.modulate = value



func _ready() -> void:
	if not VISIBLE_FOR_DEBUG and not Engine.editor_hint:
		NumberLabel.visible = false
	NumberLabel.text = str(ORDER_NUMBER)
	NumberLabel.modulate = COLOR


func _draw() -> void:
	if not VISIBLE_FOR_DEBUG and not Engine.editor_hint:
		return
	draw_line(Vector2(-5, 0), Vector2(5, 0), COLOR, 1.2)
	draw_line(Vector2(0, -5), Vector2(0, 5), COLOR, 1.2)
	

func set_as_start() -> void:
	ORDER_NUMBER = 0