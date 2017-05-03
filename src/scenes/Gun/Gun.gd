extends Node2D

var gun_texture = null
var shots = []
var gun_sprite = null

var default_json = {
	"gun_texture": "res://assets/imgs/gear/guns/gun01.png",
	"shots": [
		{
			"bullet_node_path": "Bullets/Bullet",
			"fire_from": { "x": 50, "y": 50 },
			"params": {
					"rigid_body_node_path": "res://assets/scenes"
				}
		}
	]
}

func _ready():
	gun_sprite = get_node("GunSprite")
	pass

func setup(json):
	gun_sprite.set_texture(load(json.gun_texture))
	shots = json.shots

func fire():
	for bullet_info in shots:
		_fire_bullet(bullet_info)
	
func _fire_bullet(bullet_info):
	print(bullet_info)
	var bullet = get_node(bullet_info.bullet_node_path).instance()
	
	var percent_pos = Vector2(bullet_info.fire_from.x, bullet_info.fire_from.y) / 100.0
	var pos_on_gun_sprite =  percent_pos * get_global_scale() + get_global_pos()
	bullet.set_position(pos_on_gun_sprite)
	
	bullet.setup(self, bullet_info.params)
