extends RigidBody2D

var movement_force = 0

func _ready():
	set_fixed_process(true)
	movement_force = get_mass() 
	pass

func _move():
	var force = Vector2()
	if Input.is_action_pressed("move_up"):
		force += Vector2(0, -movement_force)
	if Input.is_action_pressed("move_down"):
		force += Vector2(0, movement_force)
	if Input.is_action_pressed("move_left"):
		force += Vector2(-movement_force, 0)
	if Input.is_action_pressed("move_right"):
		force += Vector2(movement_force, 0)
	
	var multiplier = 1
	if Input.is_action_pressed("power_move"):
		multiplier = 10
	
	apply_impulse(Vector2(), force * multiplier)

#PID controller gain values
var PID_Kp = 1000.0
var PID_Ki = 100.0
var PID_Kd = 1000.0
var _P  = 0
var _I = 0
var _D = 0
var _prev_error = 0
func _get_PID_output(currentError, delta):
	_P = currentError
	_I += _P * delta
	_D = (_P - _prev_error) / delta
	_prev_error = currentError
	   
	return _P*PID_Kp + _I*PID_Ki + _D*PID_Kd

func _rotate_towards_movement(delta):
	var angle_btw = get_linear_velocity().angle()
	var error = get_global_rot() - angle_btw
	#deal with angle discontinuity
	#https://stackoverflow.com/questions/10697844/how-to-deal-with-the-discontinuity-of-yaw-angle-at-180-degree
	if(error > PI): 
	   error = error - PI * 2
	elif(error < -PI):
	   error = error + PI * 2
	
	var torque = _get_PID_output(error,delta)
	set_applied_torque(torque)

func _fixed_process(delta):
	_move()
	_rotate_towards_movement(delta)