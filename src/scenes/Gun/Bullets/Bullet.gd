extends Node2D

export var kill_out_of_bounds = false
export var lifespan = 0 setget set_lifespan, get_lifespan
var rigid_body = null
var gun_shot_from = null
var _timer = null

func setup(shooting_gun, json):
	gun_shot_from = shooting_gun
	rigid_body = get_node(json.rigid_body_node_path).instance()
	add_child(rigid_body)
	return 0

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
	_timer = Timer.new()
	_timer.connect("timeout",self,"_die") 
	pass
	
func _process():
	
	pass