extends Enemy


var forward_vector : Vector2 = Vector2(1, 0)

var has_touched_ground : bool = false


## @Override
func _physics_process(delta: float) -> void:
	if not has_touched_ground and is_on_floor():
		has_touched_ground = true
	._physics_process(delta)
	

## @Override
func process_movement(delta : float) -> void:
	if is_on_floor() :
		linear_velocity = forward_vector * MOVEMENT_SPEED
	else:
		if has_touched_ground:
			print("not on ground")
			linear_velocity.x = 0
			rotation_degrees = 90
			gravity_vector = Vector2(-1, 0)
			forward_vector = Vector2(0, 1)
			

