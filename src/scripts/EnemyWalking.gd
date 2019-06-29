extends Enemy
class_name EnemyWalking

################################
#	Nodes variables
onready var FeelGround : RayCast2D = get_node("FeelGround")
onready var FeelFront : RayCast2D = get_node("FeelFront")




################################
#	Custom functions
#	processors
##	@Override
func process_movement(delta : float) -> void:
	if is_on_floor():
		if !FeelGround.is_colliding() or FeelFront.is_colliding() :
			flip_facing()
		linear_velocity.x = MOVEMENT_SPEED * facing

#	life
##	@Override
func flip_facing() -> void:
	.flip_facing()
	FeelGround.position.x = abs(FeelGround.position.x) * facing
	FeelFront.position.x = abs(FeelFront.position.x) * facing
	FeelFront.cast_to.x = abs(FeelFront.cast_to.x) * facing