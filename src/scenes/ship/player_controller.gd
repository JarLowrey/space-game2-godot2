extends RigidBody2D

var force_amt = 50
export var rot_speed_divider = 7

func _ready():
	set_process(true)
	pass

func _move():
	var force = Vector2()
	var pressed = false
	if Input.is_action_pressed("move_up"):
		pressed = true
		force += Vector2(0, -force_amt)
	if Input.is_action_pressed("move_down"):
		pressed = true
		force += Vector2(0, force_amt)
	if Input.is_action_pressed("move_left"):
		pressed = true
		force += Vector2(-force_amt, 0)
	if Input.is_action_pressed("move_right"):
		pressed = true
		force += Vector2(force_amt, 0)
	
	if pressed:
		apply_impulse(Vector2(), force)
		get_node("/root/global")._set_rotation(get_node("Sprite"), force.angle(), rot_speed_divider)
		get_node("/root/global")._set_rotation(get_node("CollisionPolygon2D"), force.angle(), rot_speed_divider)

func _process(delta):
	_move()