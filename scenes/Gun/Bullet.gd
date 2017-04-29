extends Node2D

export var kill_out_of_bounds = false
export var lifespan = 0 setget set_lifespan, get_lifespan

var timer = null

func set_lifespan(span):
	timer.set_wait_time(span)
	timer.start()
	
func get_lifespan():
	return timer.get_time_left()
	
func _die():
	print("bullet was deleted")
	free()
	return 

func _ready():
	timer = Timer.new()
	timer.connect("timeout",self,"_die") 
	pass
	
func _process():
	
	pass