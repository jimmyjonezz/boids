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
	_boids()
	randomize()
	_rand_destination()
	$anim.seek(rand_range(1, 3))
	
func _physics_process(delta) -> void:
	acceleration = Vector2.ZERO
	var distance = (destination - position).length()
	
	if !touch:
		vector = (destination - position).normalized() * max_velocity
	else:
		vector = (position - destination).normalized() * max_velocity
		_boids()
	
	_direction()
	
	velocity = velocity.linear_interpolate(vector, delta * FOLLOW_SPEED)
	
	var rnd = rand_range(10, 20)
	if distance < rnd:
		_friction()
		
	var collision = move_and_collide(velocity)
	if collision:
		print(collision)
	
	update()
	
func _boids():
	var end = Vector2.ZERO
	var n = get_node("../../YSort").get_children()
	var count = get_node("../../YSort").get_children().size()
	for x in n:
		end += x.position
		
	var num = end / count
	return num

func _rand_destination() -> void:
	destination = Vector2(randf() * get_viewport_rect().size.x / 3,
			randf() * get_viewport_rect().size.y / 3)

#поворот спрайта
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
		_boids()
		touch = false
		
func _draw():
	draw_circle(_boids(), 10, ColorN("red", 1.0))
