extends Node

#singleton in godot:
#http://docs.godotengine.org/en/2.1/learning/step_by_step/singletons_autoload.html

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func resize_to(ref_rec, resizable):
    var size = ref_rec.size
    var pos = -size/2
    resizable.edit_set_rect(Rect2(pos,size))

func _set_rotation(node, dest_angle,rot_speed_divider):
	var curr = node.get_global_rot()
	
	#ensure always turn the quickest direction
	var error = dest_angle - curr
	if(error > PI):  
	   error = error - PI * 2
	elif(error < -PI):
	   error = error + PI * 2
	
	var step  = error / rot_speed_divider
	node.rotate(step)