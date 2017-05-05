extends Node2D

var shots = []
var gun_sprite = null
var bullets = null

var test_json = {
	"shots": [
		{
			"bullet_scene": "res://src/scenes/Gun/Bullets/Bullet.tscn",
			"params": {
					"fire_from": { "x": 50, "y": 0 }
				}
		}
	]
}

func _ready():
	set_rotd(45)
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
