extends Object
class_name FacingDirs

const RIGHT : int = 1
const LEFT : int = -1

static func get_h_flip(direction : int = RIGHT) -> bool:
	return direction == LEFT