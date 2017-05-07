extends Node2D

var shots = []
var gun_sprite = null
export var fire_rate = 0 setget set_auto_fire

signal volley_fired
signal out_of_ammo

func set_auto_fire(fire_rate_in_sec):
	fire_rate = fire_rate_in_sec
	var timer = get_node("AutoFireTimer")
	if fire_rate > 0:
		timer.set_wait_time(fire_rate)
		timer.start()
	else:
		timer.stop()

func stop_firing():
	set_auto_fire(-1)

var test_json = {
	"auto_fire": {
		"fire_immediately": true,
		"fire_rate": 1.5
	},
	"shots": [
		{
			"ammo": 2,
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
	for shot in shots:
		if !shot.has("ammo"):
			shot.ammo = -1
	
	if json.has("auto_fire"):
		set_auto_fire(json.auto_fire.fire_rate)		
		if json.auto_fire.has("fire_immediately") and json.auto_fire.fire_immediately:
			fire()

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
		if bullet_info.ammo > 0 or bullet_info.ammo < 0:
			var fired_bullet = _fire_bullet(bullet_info)
			bullets.append(fired_bullet)
			bullet_info.ammo -= 1
			if (bullet_info.ammo + 1) > 0 and bullet_info.ammo <= 0:
				emit_signal("out_of_ammo", bullet_info)
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