extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var gun_frame = "";

func _init():
	pass
	
func _ready():
	var sprite = get_node("GunSprite")
	sprite.set_texture(load("res://assets/imgs/"+gun_frame))
	pass
