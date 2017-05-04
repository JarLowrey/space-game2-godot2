extends Node2D

var shots = []
var gun_sprite = null
var bullets = null

var test_json = {
	"shots": [
		{
			"bullet_scene": "res://src/scenes/Gun/Bullets/Bullet.tscn",
			"speed": 300,
			"fire_from": { "x": 50, "y": 0 },
			"params": {
				}
		}
	]
}

func _ready():
	set_rotd(270)
	gun_sprite = get_node("GunSprite")
	bullets = get_node("Bullets")
	setup(test_json)
	fire()
	pass

func setup(json):
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
	var pos_on_gun_sprite =  percent_pos * gun_sprite.get_item_rect().size + gun_sprite.get_pos()
	bullet.set_pos(pos_on_gun_sprite)
	
	bullet.set_global_rot(get_global_rot())
		
	#set bullet speed
	var vx = bullet_info.speed * cos(-get_global_rot()) #idk why this is negative?
	var vy = bullet_info.speed * sin(-get_global_rot())
	bullet.rigid_body.set_linear_velocity(Vector2(vx,vy))
