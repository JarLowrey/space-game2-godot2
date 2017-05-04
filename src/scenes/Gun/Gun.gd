extends Node2D

var shots = []
var gun_sprite = null
var bullets = null

var test_json = {
	"texture": "res://assets/imgs/gear/guns/gun01.png",
	"shots": [
		{
			"bullet_scene": "res://src/scenes/Gun/Bullets/Bullet.tscn",
			"speed": 50,
			"fire_from": { "x": 50, "y": 50 },
			"params": {
					"texture":"res://assets/imgs/bullets/laserBlue01.png",
					"rigid_body_scene": "res://assets/godot/scenes/bodies/default_bullet.tscn",
					"collision_polygon_scene": "res://assets/godot/scenes/polygon2Ds/rectangle.tscn"
				}
		}
	]
}

func _ready():
	gun_sprite = get_node("GunSprite")
	bullets = get_node("Bullets")
	setup(test_json)
	fire()
	pass

func setup(json):
	gun_sprite.set_texture(load(json.texture))
	shots = json.shots

func fire():
	for bullet_info in shots:
		_fire_bullet(bullet_info)
	
func _fire_bullet(bullet_info):
	var bullet = load(bullet_info.bullet_scene).instance()
	bullet.setup(self, bullet_info.params)
	bullets.add_child(bullet)
	
	#set bullet position
	var percent_pos = Vector2(bullet_info.fire_from.x, bullet_info.fire_from.y) / 100.0
	var pos_on_gun_sprite =  percent_pos * get_scale() + get_pos()
	bullet.set_pos(pos_on_gun_sprite)
	
	#set bullet speed
	var vx = bullet_info.speed * cos(get_rot())
	var vy = bullet_info.speed * sin(get_rot())
	bullet.rigid_body.set_linear_velocity(Vector2(vx,vy))
