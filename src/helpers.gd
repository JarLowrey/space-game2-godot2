extends Node2D

func aim_angle(bullet, target):
	print()

func aim():
	print("what has happened to my life")

func calculate_intercept_course():
	print()

func predict_pos(body, time):
	var a = body.get_applied_force() / body.get_mass()
	var a_term = 0.5 * a * pow(time,2)
	var v = body.get_velocity() * time
	return body.get_global_pos() + v + accel

func intercept_pos():
	