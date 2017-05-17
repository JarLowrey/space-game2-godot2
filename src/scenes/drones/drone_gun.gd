extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var target = null

func set_target(node):
	target = null

func clear_target(node):
	if node == target:
		target = null

func _process(delta):
	if target:
		var dest_angle = get_global_pos().angle_to(target.get_global_pos())
		get_node("/root/global")._set_rotation(self, dest_angle, 7)
		if(abs(dest_angle - get_global_rot()) < 5):
			_make_laser_hit_target()
			_mine_resources()

func _make_laser_hit_target():
	print("hits")
	get_node("../laser").set_hidden(false)
	var laser = get_node("../laser")
	var laser_height = laser.get_item_rect().size.y
	var dist_to_targ = get_global_pos().distance_to(target.get_global_pos())
	get_node("/root/global").resize_to(Rect2(0,0,dist_to_targ,laser_height), laser)

func _mine_resources():
	return 

func _ready():
	set_process(true)
	get_node("../laser").set_hidden(true)
	var mining_zone = get_node("../range")
	mining_zone.connect("body_enter",self,"set_target")
	mining_zone.connect("area_enter",self,"set_target")
	mining_zone.connect("body_exit",self,"clear_target")
	mining_zone.connect("area_exit",self,"clear_target")
	pass
