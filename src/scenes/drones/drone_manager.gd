extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var intersection_radius = 10.0 setget set_intersection_radius

func set_intersection_radius(val):
	intersection_radius = val
	get_node("drone_area").get_node("collider").get_shape().set_radius(intersection_radius)

func _ready():
	pass
