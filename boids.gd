extends KinematicBody2D

var velocity = Vector2.ZERO
var destination = Vector2.ZERO
#var direction = Vector2.ZERO
var vector = Vector2.ZERO
var acceleration = Vector2.ZERO
var child_pos = Vector2.ZERO

var friction = -0.12
var drag = -0.001

var max_velocity = 1.2
var FOLLOW_SPEED = 1

var touch = false

func _ready() -> void:
	randomize()
	_rand_destination()
	$anim.seek(rand_range(1, 3))
	
func _physics_process(delta) -> void:
	acceleration = Vector2.ZERO
	var distance = (destination - position).length()
	#var angle = (destination - position).angle()
	
	if !touch:
		vector = (destination - position).normalized() * max_velocity
	else:
		vector = (position - destination).normalized() * max_velocity
		_next()
	
	_direction()
	
	velocity = velocity.linear_interpolate(vector, delta * FOLLOW_SPEED)
	
	if distance < 15:
		_friction()
	
	if distance < 2:
		_rand_destination()
	
	#_friction()
	#velocity += acceleration * delta
		
	var collision = move_and_collide(velocity)
	if collision:
		return
	    #print(collision)
		#var reflect = collision.remainder.bounce(collision.normal)
	    #velocity = velocity.bounce(collision.normal)
	    #move_and_collide(reflect)

	#print("destination: %s, pos: %s, vec: %s, vel: %s" % 
	#		[destination, position, vector, velocity])
	
func _next():
	#print(position)
	var child = get_parent().get_children()
	#print(child)
	var rand_count = randi() % child.size()
	child_pos = child[rand_count].global_position
	#print(rand_cound)
	if position.round() == child_pos.round():
		child_pos = child[rand_count].global_position
	else:
		_next()
	#print(destination)

func _rand_destination() -> void:
	destination = Vector2(randf() * get_viewport_rect().size.x / 3,
			randf() * get_viewport_rect().size.y / 3)

func _direction():
	if sign(vector.x) == 1:
		$image.flip_h = true
	else:
		$image.flip_h = false
	
func _friction():
	var friction_force = velocity * friction
	var force = velocity * velocity.length() * drag
	velocity += force + friction_force

func _on_area_area_entered(area):
	if area.name == "area":
		#$CollisionShape2D.set_deferred("disabled", true)
		touch = true

func _on_area_area_exited(area):
	if area is Area2D:
		#_rand_destination()
		yield(get_tree().create_timer(0.6), "timeout")
		touch = false
		_rand_destination()
