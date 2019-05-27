extends Enemy
class_name EnemyFlying

################################
#	Nodes variables


################################
#	Other variables
var nav_points : PoolVector2Array = []


func _ready() -> void:
	apply_gravity = false
	print(nav_points)






