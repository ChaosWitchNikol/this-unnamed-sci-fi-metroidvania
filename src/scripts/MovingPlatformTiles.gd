tool
extends TileMap

var one_way : bool = false setget __set_one_way
var size_x : int = 16 setget __set_size_x


func __set_one_way(value : bool) -> void:
	one_way = value
	set_tiles()

func __set_size_x(value : int) -> void:
	size_x = value
	position.x = - (size_x / 2)
	set_tiles()
	


func set_tiles() -> void:
	clear()
	var add = 3
	if one_way:
		add = 0
	var number_of_tiles = size_x / Const.TILE_SIZE
	#	set first cell	
	set_cell(0, 0, 0 + add)
	#	set last cell
	set_cell(number_of_tiles - 1, 0, 0 + add, true)
	
	if number_of_tiles > 2:
		for index in range(1, number_of_tiles - 1):
			set_cell(index, 0, 1 + add)
		


