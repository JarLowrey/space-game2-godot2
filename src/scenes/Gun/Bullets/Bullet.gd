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
	collision_polygon = load(json.collision_polygon_scene).instance()
	rigid_body = load(json.rigid_body_scene).instance()
	
	print(sprite)
	sprite.add_child(rigid_body)
	rigid_body.add_child(collision_polygon)

func set_lifespan(span):
	_timer.set_wait_time(span)
	_timer.start()
	
func get_lifespan():
	return _timer.get_time_left()
	
func _die():
	print("bullet was deleted")
	free()
	return 

func _ready():
	sprite = get_node("Sprite")
	_timer = Timer.new()
	_timer.connect("timeout",self,"_die") 
	pass
	
func _process():
	
	pass