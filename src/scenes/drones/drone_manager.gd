extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var intersection_radius = 10.0 setget set_intersection_radius
var target = null

func set_intersection_radius(val):
	intersection_radius = val
	if has_node("area/collider"):
		get_node("area/collider").get_shape().set_radius(intersection_radius)

func add_drones(drones):
	for drone_scene in drones:
		var drone = load(drone_scene).instance()
		get_node("drones").add_child(drone)

func hide_drones():
	for drone in get_node("drones").get_children():
		drone.hide()

func set_target(node):
	target = node
	for drone in get_node("drones").get_children():
		drone.set_target(target)

func clear_target(node):
	if node == target:
		target = null
		for drone in get_node("drones").get_children():
			drone.set_target(null)

func _ready():
	var mining_zone = get_node("area")
	mining_zone.connect("body_enter",self,"set_target")
	mining_zone.connect("area_enter",self,"set_target")
	mining_zone.connect("body_exit",self,"clear_target")
	mining_zone.connect("area_exit",self,"clear_target")
	pass
