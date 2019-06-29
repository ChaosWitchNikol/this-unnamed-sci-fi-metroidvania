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


################################
#	Custom functions
#	processors
##	@Override
func process_movement(delta : float) -> void:
	if player_to_follow:
		linear_velocity = (player_to_follow.position - position).normalized() * MOVEMENT_SPEED

################################
#	Setters
##	@Override
func set_view_ditance(value : float = 8.0) -> void:
	.set_view_distance(value)
	$ViewRay.cast_to.y = value

##	@Override
func set_player_to_follow(value : Player) -> void:
	if not player_to_follow:
		var ray_angle : float = round(rad2deg($ViewRay.cast_to.angle()))
		var player_angle : float = round(rad2deg(value.position.angle()))
		if player_angle in range(ray_angle - view_half_angle, ray_angle + view_half_angle):
			player_to_follow = value




