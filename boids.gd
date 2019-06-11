extends KinematicBody2D

var velocity = Vector2.ZERO
var max_velocity = 100
var destination = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta):
	var vector = (destination - position).normalized()
	velocity = vector * max_velocity
	move_and_collide(velocity * delta)
	
	print("destination: %s, pos: %s, vec: %s, vel: %s" % 
			[destination, position, vector, velocity])

func _on_timer_timeout():
	destination = Vector2(randf() * get_viewport_rect().size.x,
			randf() * get_viewport_rect().size.y)
