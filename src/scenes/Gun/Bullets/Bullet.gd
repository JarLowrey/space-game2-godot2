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
	
	#create/fetch node instances
	sprite = get_node("Sprite")
	collision_polygon = load(json.collision_polygon_scene).instance()
	rigid_body = load(json.rigid_body_scene).instance()
	
	#add node children
	sprite.add_child(rigid_body)
	
	print(json.collision_polygon_scene)
	rigid_body.add_child(collision_polygon)
	
	#apply json customization to nodes
	sprite.set_texture(load(json.texture))

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