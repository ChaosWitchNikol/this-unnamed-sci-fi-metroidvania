extends Object
class_name Const


const TILE_SIZE : int = 8
const TILE_HALF_SIZE : int = TILE_SIZE / 2


class FacingDirections:
	const RIGHT : int = 1
	const LEFT : int = -1
	
	static func get_h_flip(direction : int) -> bool:
		return direction == LEFT