extends KinematicBody2D

var movement_amt = 10
export var rot_speed_divider = 7

func _ready():
	set_fixed_process(true)
	pass

func _move():
	var movement = Vector2()
	if Input.is_action_pressed("move_up"):
		movement += Vector2(0, -movement_amt)
	if Input.is_action_pressed("move_down"):
		movement += Vector2(0, movement_amt)
	if Input.is_action_pressed("move_left"):
		movement += Vector2(-movement_amt, 0)
	if Input.is_action_pressed("move_right"):
		movement += Vector2(movement_amt, 0)
	
#	var multiplier = 1
#	if Input.is_action_pressed("power_move"):
#		multiplier = 10
	
	move(movement)
	
func _set_rotation():
	var dest = get_travel().angle()
	var curr = get_global_rot()
	
	#ensure always turn the quickest direction
	var error = dest-curr
	if(error > PI):  
	   error = error - PI * 2
	elif(error < -PI):
	   error = error + PI * 2
	
	var step  = error / rot_speed_divider
	rotate(step)

func _fixed_process(delta):
	_move()
	_set_rotation()