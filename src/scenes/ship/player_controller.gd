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
		get_node("/root/global")._set_rotation(get_node("rotating_nodes"), movement.angle(), rot_speed_divider)

func _process(delta):
	_move()