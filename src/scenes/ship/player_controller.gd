extends KinematicBody2D

var movement_amt = 10
export var rot_speed_divider = 7

func _ready():
	set_process(true)
	set_rotd(180)
	pass

func _move():
	var movement = Vector2()
	var pressed = false
	if Input.is_action_pressed("move_up"):
		pressed = true
		movement += Vector2(0, -movement_amt)
	if Input.is_action_pressed("move_down"):
		pressed = true
		movement += Vector2(0, movement_amt)
	if Input.is_action_pressed("move_left"):
		pressed = true
		movement += Vector2(-movement_amt, 0)
	if Input.is_action_pressed("move_right"):
		pressed = true
		movement += Vector2(movement_amt, 0)
	
	if pressed:
		move(movement)
		_set_rotation(movement)
	
func _set_rotation(dir):
	var dest = dir.angle()
	var rotating_node = get_node("rotating_nodes")
	var curr = rotating_node.get_global_rot()
	
	#ensure always turn the quickest direction
	var error = dest-curr
	if(error > PI):  
	   error = error - PI * 2
	elif(error < -PI):
	   error = error + PI * 2
	
	var step  = error / rot_speed_divider
	rotating_node.rotate(step)

func _process(delta):
	_move()