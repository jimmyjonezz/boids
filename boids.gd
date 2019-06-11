extends KinematicBody2D

var velocity = Vector2.ZERO
var max_velocity = 4
var destination = Vector2.ZERO
var FOLLOW_SPEED = 2

func _ready():
	pass
	
func _physics_process(delta):
	var vector = (destination - position).normalized() * max_velocity
	velocity = velocity.linear_interpolate(vector, delta * FOLLOW_SPEED)
	move_and_collide(velocity)
	
	#print("destination: %s, pos: %s, vec: %s, vel: %s" % 
	#		[destination, position, vector, velocity])

func _on_timer_timeout():
	destination = Vector2(randf() * get_viewport_rect().size.x,
			randf() * get_viewport_rect().size.y)
