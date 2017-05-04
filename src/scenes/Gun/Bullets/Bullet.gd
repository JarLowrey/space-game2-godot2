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
	_setup_nodes(json)
	
func _setup_nodes(json):
	#use json nodes if they are definied, otherwise use the editor nodes
	print(json)
	if(json.has("rigid_body_scene")):
		rigid_body = load(json.rigid_body_scene).instance()
		add_child(rigid_body)
		get_node("RigidBody2D").free()
		if(json.has("sprite_scene")):
			sprite = load(json.sprite_scene).instance()
			rigid_body.add_child(sprite)
		if(json.has("collision_polygon_scene")):
			collision_polygon = load(json.collision_polygon_scene).instance()
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