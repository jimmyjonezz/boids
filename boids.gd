extends KinematicBody2D

var velocity = Vector2.ZERO
var max_velocity = 100

func _ready():
	pass
	
func _physics_process(delta):
	velocity = (get_global_mouse_position() - position).normalized() * max_velocity
	move_and_collide(velocity * delta)