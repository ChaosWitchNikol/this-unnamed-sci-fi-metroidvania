extends Enemy
class_name EnemyFlying

################################
#	Nodes variables
onready var Nav : Navigation2D = get_node("Nav")

func _ready() -> void:
	apply_gravity = false

