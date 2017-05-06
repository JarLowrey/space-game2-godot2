extends Node2D

var shots = []
var gun_sprite = null
export var fire_rate = 0 setget set_fire_rate
signal volley_fired

func set_fire_rate(val):
	fire_rate = val
	if val > 0:
		get_node("AutoFireTimer").set_wait_time(val)
	else:
		get_node("AutoFireTimer").stop()

var test_json = {
	"auto_fire": {
		"fire_immediately": true,
		"fire_rate": 1.5
	},
	"shots": [
		{
			"bullet_scene": "res://src/scenes/Gun/Bullets/Bullet.tscn",
			"params": {
					"fire_from": { "x": 50, "y": 0 },
					"death":{
						"time":1,
						"collision":true,
						"screen":true,
						"distance":500
					}
				}
		}
	]
}
var signals = []

func setup(json):
	shots = json.shots
	if json.has("auto_fire"):
		fire_rate = json.auto_fire.fire_rate
		
		if json.auto_fire.has("fire_immediately") and json.auto_fire.fire_immediately:
			print("ASD")
			fire()
		get_node("AutoFireTimer").set_wait_time(fire_rate)
		get_node("AutoFireTimer").start()

func _ready():
	gun_sprite = get_node("GunSprite")
	get_node("AutoFireTimer").connect("timeout", self, "fire") 
	setup(test_json)
	add_bullet_body_signal("bullet_killed", self, "test_signal")
	pass

func test_signal():
	print("AAAAAAAAAAAAAAA signal")

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
	var bullets = []
	for bullet_info in shots:
		bullets.append(_fire_bullet(bullet_info))
	emit_signal("volley_fired",bullets)
	
func _fire_bullet(bullet_info):
	var bullet = load(bullet_info.bullet_scene).instance()
	bullet.setup(self, bullet_info.params)
	get_node("Bullets").add_child(bullet)
	
#	#Make sure signals always fire
#	bullet.set_contact_monitor(true) #you're attaching a signal, ensure it will be fired!
#	var num_contacts_reported = max(bullet.get_max_contacts_reported(), 1)
#	bullet.set_max_contacts_reported( num_contacts_reported ) #ensure at least 1 contact reported
	
	for sig_info in signals:
		bullet.connect(sig_info["name"], sig_info["node"], sig_info["method"], sig_info["binds"], sig_info["flags"])
	return bullet