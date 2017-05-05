extends Node2D

var shots = []
var gun_sprite = null

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

var signals = []

func setup(json):
	shots = json.shots

func _ready():
	gun_sprite = get_node("GunSprite")
	setup(test_json)
	add_bullet_body_signal("body_enter", self, "test_signal")
	fire()
	pass

func test_signal(body):
	print(body," signal")

func remove_bullet_body_signal(sig_name,node,method):
	for i in range(0,signals.size()):
		var sig = signals[i]
		if sig["name"] == sig_name and sig["node"] == node and sig["method"] == method:
			signals.remove(i)
	
	for bullet in get_node("Bullets").get_children():
		bullet.disconnect(sig_name,node,method)

func add_bullet_body_signal(sig_name, node, method, binds=Array(), flags=0):
	signals.append({
		"name": sig_name,
		"node": node,
		"method": method,
		"binds": binds,
		"flags":flags
	})
	for bullet in get_node("Bullets").get_children():
		bullet.connect(sig_name,node,method,binds,flags)

func fire():
	for bullet_info in shots:
		_fire_bullet(bullet_info)
	
func _fire_bullet(bullet_info):
	var bullet = load(bullet_info.bullet_scene).instance()
	bullet.setup(self, bullet_info.params)
	get_node("Bullets").add_child(bullet)
	
#	#Make sure signals always fire
#	bullet.set_contact_monitor(true) #you're attaching a signal, ensure it will be fired!
#	var num_contacts_reported = max(bullet.get_max_contacts_reported(), 1)
#	bullet.set_max_contacts_reported( num_contacts_reported ) #ensure at least 1 contact reported
	
	for sig_info in signals:
		print(sig_info)
		bullet.connect(sig_info["name"], sig_info["node"], sig_info["method"], sig_info["binds"], sig_info["flags"])
