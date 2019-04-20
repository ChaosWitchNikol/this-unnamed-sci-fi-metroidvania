extends KinematicBody2D
class_name Enemy

onready var Body : CollisionShape2D = get_node("Body")
onready var NextAttackTimeout : Timer = get_node("NextAttackTimeout")

var passive : bool = false
var view_distance : float = 8.0
var view_angle : float = 120.0
var attack_range : float = 1.0
var attack_delay : float = 0.01



