extends Node2D

var collision_polygon = null
var sprite = null
var gun_shot_from = null

var deleted = false

var _kill_dist = 0
var _traveled_dist = 0
var _prev_pos = null
var _scale_velocity = null
var _max_scale = null

signal bullet_killed

func setup(shooting_gun, json):
	gun_shot_from = shooting_gun
	_setup_nodes(json)
	_setup_bullet(json)
	set_fixed_process(true)
	
func _setup_bullet(bullet_info):
	_scale_velocity = bullet_info.scale_velocity
	if bullet_info.has("max_scale"):
		_max_scale = bullet_info.max_scale
	#set bullet position
	var offset = Vector2(bullet_info.fire_from[0], bullet_info.fire_from[1])
	set_pos(gun_shot_from.gun_sprite.get_global_pos() + offset)
	
	set_global_rot(gun_shot_from.get_global_rot())
	
	#set bullet speed
	var speed = sqrt(get_linear_velocity().length_squared()) #magnitude of rigid body's linear velocity
	var vx = speed * cos(-get_global_rot()) #idk why this is negative?
	var vy = speed * sin(-get_global_rot())
	set_linear_velocity(Vector2(vx,vy))
	
	set_death_params(bullet_info.death)
	
func scale_bullet():
	var size = get_scale()
	var new_x = size.x + _scale_velocity[0]
	var new_y = size.y + _scale_velocity[1]
	if _max_scale != null:
		if new_x > _max_scale[0]:
			new_x = size.x
		if new_y > _max_scale[1]:
			new_y = size.y
	set_scale(Vector2(new_x,new_y))

func set_death_params(json):
	if json.has("collision") and json.collision:
		connect("body_enter", self, "kill")
	if json.has("distance"):
		_kill_dist = json.distance
		_prev_pos = get_global_pos()
	if json.has("time"):
		var timer = Timer.new()
		timer.connect("timeout",self,"kill") 
		timer.set_one_shot(true)
		timer.set_wait_time(json.time)
		add_child(timer)
		timer.start()
	if json.has("screen"):
		var vis_notify = VisibilityNotifier2D.new()
		add_child(vis_notify)
		vis_notify.connect("exit_screen",self,"kill")
	
func _fixed_process(delta):
	#increment travel distance if that is a death param
	if _prev_pos != null and !deleted:
		_traveled_dist += get_global_pos().distance_to(_prev_pos)
		if(_traveled_dist >= _kill_dist):
			kill()
		else:
			_prev_pos = get_global_pos()
	pass

func _process(delta):
	if _scale_velocity != null:
		scale_bullet()
	pass
func _ready():
	set_process(true)
	pass

func _setup_nodes(json):
	#use json nodes if they are definied, otherwise use the editor nodes
#	if(json.has("scenes")):
#		rigid_body = load(json.scenes.rigid_body).instance()
#		add_child(rigid_body)
#		get_node("RigidBody2D").free()
#		
#		sprite = load(json.scenes.sprite).instance()
#		rigid_body.add_child(sprite)
#		
#		collision_polygon = load(json.scenes.collision_polygon).instance()
#		rigid_body.add_child(collision_polygon)
#	else:
	sprite = get_node("Sprite")
	collision_polygon = get_node("CollisionShape2D")
	resize_to(sprite,collision_polygon)

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