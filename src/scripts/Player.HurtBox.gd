extends Area2D
class_name PlayerHurtBox


################################
#	Getters
func get_player() -> Player:
	return self.get_parent() as Player