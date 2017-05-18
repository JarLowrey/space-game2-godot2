extends Node2D

var hide = false
var speed = 5
var drone_manager = null
var target = null setget set_target

func set_target(node):
	target = node

func _check_for_new_direction():
	#pick a new direction if drone is far away from ship
	var dist_from_ship = get_pos().distance_to(Vector2(0,0))
	if dist_from_ship > _max_dist():
		return _set_new_direction()
	return null


#func _orbit():
#	orbit_angle += 1
#	var rad = deg2rad(orbit_angle)
#	var radius = get_pos().distance_to(Vector2(0,0))
#	var x = cos(rad) * radius
#	var y = sin(rad) * radius
#	set_pos(Vector2(x,y))

func _max_dist():
	return drone_manager.get_node("area/collider").get_shape().get_radius()

func _dir_to(global_pos):
	var angle_to = get_global_pos().angle_to_point(global_pos)
	var vx = speed * cos(-angle_to) #idk why this is negative?
	var vy = speed * sin(-angle_to)
	return Vector2(vx,vy)

func _process(delta):
	var pos = get_pos()
	var movement_dir = Vector2()
	if hide and pos.x != 0 and pos.y != 0:
		movement_dir = _dir_to(drone_manager.get_global_pos())
	elif target:
		movement_dir = _dir_to(target.get_global_pos())
	elif !target:
		var new_dir = _check_for_new_direction()
		if new_dir != null:
			movement_dir = new_dir
	
	get_node("/root/global")._set_rotation(self, movement_dir.angle() + PI/2, 15)
	
	set_pos(get_pos() + movement_dir)

func _set_new_direction():
	var rand_vec = Vector2(_max_dist() * rand_range(0,1),_max_dist() * rand_range(0,1))
	var dir_to_ship = _dir_to(drone_manager.get_pos())
	return dir_to_ship 
	
func _ready():
	drone_manager = get_node("../../")
	_set_new_direction()
	set_process(true)
	pass