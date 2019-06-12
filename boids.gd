extends KinematicBody2D

var velocity = Vector2.ZERO
var max_velocity = 4
var destination = Vector2.ZERO
var vector = Vector2.ZERO
var FOLLOW_SPEED = 2
var touch = false

func _ready():
	randomize()
	_rand_destination()
	
func _physics_process(delta):
	if touch == false:
		vector = (destination - position).normalized() * max_velocity
	else:
		vector = (position - destination).normalized() * max_velocity
		
	velocity = velocity.linear_interpolate(vector, delta * FOLLOW_SPEED)
	move_and_collide(velocity)
	
	#print("destination: %s, pos: %s, vec: %s, vel: %s" % 
	#		[destination, position, vector, velocity])

func _rand_destination():
	destination = Vector2(randf() * get_viewport_rect().size.x,
			randf() * get_viewport_rect().size.y)

func _on_timer_timeout():
	_rand_destination()

func _on_area_area_entered(area):
	if area.name == "area":
		#$CollisionShape2D.set_deferred("disabled", true)
		touch = true

func _on_area_area_exited(area):
	touch = false
	_rand_destination()
