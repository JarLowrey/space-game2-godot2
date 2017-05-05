extends Node2D

var rigid_body = null
var collision_polygon = null
var sprite = null
var gun_shot_from = null

var _timer = null
var kill_out_of_bounds = false
var lifespan = 0 setget set_lifespan, get_lifespan

func setup(shooting_gun, json):
	gun_shot_from = shooting_gun
	print(json)
	_setup_nodes(json)
	_setup_bullet(json)
	
func _setup_bullet(bullet_info):
	#set bullet position
	var percent_pos = Vector2(bullet_info.fire_from.x, bullet_info.fire_from.y) / 100.0
	var gun_size = gun_shot_from.gun_sprite.get_item_rect().size
	var gun_pos = gun_shot_from.gun_sprite.get_pos()
	var pos_on_gun_sprite =  percent_pos * gun_size + gun_pos
	set_pos(pos_on_gun_sprite)
	
	#set bullet speed
	var speed = sqrt(rigid_body.get_linear_velocity().length_squared()) #magnitude of rigid body's linear velocity
	var vx = speed * cos(get_global_rot()) #idk why this is negative?
	var vy = speed * sin(get_global_rot())
	rigid_body.set_linear_velocity(Vector2(vx,vy))
	
func _setup_nodes(json):
	#use json nodes if they are definied, otherwise use the editor nodes
	if(json.has("scenes")):
		rigid_body = load(json.scenes.rigid_body).instance()
		add_child(rigid_body)
		get_node("RigidBody2D").free()
		
		sprite = load(json.scenes.sprite).instance()
		rigid_body.add_child(sprite)
		
		collision_polygon = load(json.scenes.collision_polygon).instance()
		rigid_body.add_child(collision_polygon)
	else:
		rigid_body = get_node("RigidBody2D")
		sprite = get_node("RigidBody2D/Sprite")
		collision_polygon = get_node("RigidBody2D/CollisionShape2D")
	resize_to(sprite,collision_polygon)

func resize_to(ref, resizable):
	var size = ref.get_item_rect().size
	var pos = -size/2
	resizable.edit_set_rect(Rect2(pos,size))

func set_lifespan(span):
	_timer.set_wait_time(span)
	_timer.start()
	
func get_lifespan():
	return _timer.get_time_left()
	
func _die():
	print("bullet was deleted")
	free()
	return 

func _init():
	_timer = Timer.new()
	_timer.connect("timeout",self,"_die") 
	pass
	
func _process():
	
	pass