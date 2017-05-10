extends Node2D

var gun_shot_from = null
const sprite_node_name = "Sprite"
const collider_node_name = "CollisionPolygon"

var deleted = false
var target = null
#misc vars
export var fire_pos_offset = [0,0]
export var tracking_angle_vel_scalar = 0
export var follow_gun = false
export var fit_collider_to_sprite = true setget set_fit_collider_to_sprite

#scaling change related vars
export var size_scaling_velocity = [0,0]
export var max_size_scale = [0,0]

#death/kill/free() related vars
export var kill_on_collide = false setget set_kill_on_collide
export var max_travel_dist = -1 setget set_max_travel_dist
export var viewport_exit_kill = false setget set_viewport_exit_kill
export var lifespan = -1 setget set_lifespan

var _traveled_dist = 0
var _prev_pos = null
var _vis_notifier = null

signal bullet_killed

func setup(shooting_gun):
	print("shot")
	gun_shot_from = shooting_gun
	
	if fit_collider_to_sprite:
		resize_to(get_node(sprite_node_name),get_node(collider_node_name))
	
	#choose parent
	var parent = null;
	var root_node = gun_shot_from.get_node("/root")
	if follow_gun:
		parent = gun_shot_from.get_node("ChildBullets")
	else:
		parent = root_node
	parent.add_child(self)
	
	#set bullet position
	var offset = Vector2(fire_pos_offset[0], fire_pos_offset[1])
	if get_parent() == root_node:
		offset +=gun_shot_from.gun_sprite.get_global_pos()
	set_pos(offset)
	
	set_global_rot(gun_shot_from.get_global_rot())
	
	_set_vel_from_angle(get_global_rot())
	
func _set_vel_from_angle(angle):
	var speed = sqrt(get_linear_velocity().length_squared()) #magnitude of rigid body's linear velocity
	var vx = speed * cos(-angle) #idk why this is negative?
	var vy = speed * sin(-angle)
	set_linear_velocity(Vector2(vx,vy))

#requires rigid_body to be in Kinematic mode
func _scale_bullet():
	var size = get_scale()
	var new_x = size.x + size_scaling_velocity[0]
	var new_y = size.y + size_scaling_velocity[1]
	if max_size_scale != null:
		if new_x > max_size_scale[0]:
			new_x = size.x
		if new_y > max_size_scale[1]:
			new_y = size.y
	set_scale(Vector2(new_x,new_y))
	
func _integrate_forces(state):
	if size_scaling_velocity[0] != 0 and size_scaling_velocity[1] != 0:
		_scale_bullet()

func _track_target():
	var angle_btw = get_global_pos().angle_to(target.get_global_pos())
	var angle_diff = get_global_rot() - angle_btw
	
	set_angular_velocity(tracking_angle_vel_scalar * angle_diff)
	_set_vel_from_angle(get_global_rot())

func set_fit_collider_to_sprite(val):
	fit_collider_to_sprite = val
	if fit_collider_to_sprite and has_node(sprite_node_name) and has_node(collider_node_name):
		resize_to(get_node(sprite_node_name),get_node(collider_node_name))
func set_lifespan(val):
	lifespan = val
	if val > 0:
		var timer = Timer.new()
		timer.connect("timeout",self,"kill") 
		timer.set_one_shot(true)
		timer.set_wait_time(lifespan)
		add_child(timer)
		timer.start()
func set_kill_on_collide(val):
	kill_on_collide = val
	if val:
		connect("body_enter", self, "kill")
func set_max_travel_dist(val):
	max_travel_dist = val
	if max_travel_dist > 0:
		_prev_pos = get_global_pos()
func set_viewport_exit_kill(val):
	viewport_exit_kill = val
	if val:
		if !_vis_notifier:
			_vis_notifier = VisibilityNotifier2D.new()
			add_child(_vis_notifier)
		_vis_notifier.connect("exit_screen",self,"kill")
	else:
		if _vis_notifier:
			_vis_notifier.disconnect("exit_screen",self,"kill")
	
func _fixed_process(delta):
	#increment travel distance if that is a death param
	if _prev_pos != null and !deleted:
		_traveled_dist += get_global_pos().distance_to(_prev_pos)
		if(_traveled_dist >= max_travel_dist):
			kill()
		else:
			_prev_pos = get_global_pos()
	pass

func _process(delta):
	if target:
		_track_target()
	pass

func _ready():
	set_process(true)
	set_fixed_process(true)
	pass

func resize_to(ref, resizable):
	var size = ref.get_item_rect().size
	var pos = -size/2
	resizable.edit_set_rect(Rect2(pos,size))

func kill(arg=null):
	#ensure freeing/signal only done once if multiple kill conditions are set up
	if(deleted):
		return
	deleted = true
	
	emit_signal("bullet_killed")
	queue_free()