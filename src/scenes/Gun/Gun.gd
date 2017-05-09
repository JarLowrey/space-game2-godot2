extends Node2D

var shots = []
var gun_sprite = null
const _timer_node = "Timers/ShotClock"
export var auto_fire = true
export var fire_delay = 1.0
export var reload_delay = 2.0
export var ammo = -1 setget set_ammo
export var clip_size = 1 setget set_clip_size
var _ammo_left_in_clip = 1
var can_fire = true setget set_can_fire

signal volley_fired
signal out_of_ammo
signal can_fire_again

func set_clip_size(val):
	clip_size = val
	if val < _ammo_left_in_clip:
		_ammo_left_in_clip = val

func set_can_fire(val):
	can_fire = val
	if val:
		emit_signal("can_fire_again")
		if auto_fire:
			fire()

func reload():
	_ammo_left_in_clip = clip_size
	can_fire = false
	get_node(_timer_node).set_wait_time(reload_delay)
	get_node(_timer_node).start()

func set_ammo(val):
	ammo = val
	if(ammo < _ammo_left_in_clip):
		_ammo_left_in_clip = ammo

var test_json = {
	"ammo":-1,
	"delay":{
		"fire": .2,
		"reload": 2
	},
	"clip_size": 2,
	"auto_fire": {
		"fire_immediately": true,
	},
	"shots": [
		{
			"bullet_scene": "res://src/scenes/Gun/Bullets/Bullet.tscn",
			"params": {
				"fire_from": { "x": 5, "y": 0 },
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
	fire_delay = json.delay.fire
	ammo = json.ammo
	get_node(_timer_node).set_wait_time(fire_delay)
	get_node(_timer_node).start()
	reload_delay = json.delay.reload
	clip_size = json.clip_size
	_ammo_left_in_clip = clip_size
	
	auto_fire = json.has("auto_fire")
	if json.has("auto_fire"):
		if json.auto_fire.has("fire_immediately") and json.auto_fire.fire_immediately:
			fire()

func _ready():
	gun_sprite = get_node("GunSprite")
	get_node(_timer_node).connect("timeout", self, "set_can_fire",[true])
	add_bullet_body_signal("bullet_killed", self, "test_signal")
	setup(test_json)
	pass

func test_signal():
	print("bullet died signal")

func remove_bullet_body_signal(sig_name,node,method):
	for i in range(0,signals.size()):
		var sig = signals[i]
		if sig["name"] == sig_name and sig["node"] == node and sig["method"] == method:
			signals.remove(i)
	
	for bullet in get_node("Bullets").get_children():
		bullet.disconnect(sig_name, node, method)

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
	if(!can_fire):
		return 
	
	var bullets = []
	for bullet_info in shots:
		var fired_bullet = _fire_bullet(bullet_info)
		bullets.append(fired_bullet)
	emit_signal("volley_fired", bullets)
	
	set_can_fire(false)
	_ammo_left_in_clip -= 1
	if ammo > 0:
		ammo -= 1
	
	#prepare to fire again if possible
	var timer = get_node(_timer_node)
	
	if (ammo + 1) > 0 and ammo <= 0:
		emit_signal("out_of_ammo")
		timer.stop()
	else:
		if _ammo_left_in_clip <= 0:
			if auto_fire:
				reload()
			else:
				timer.stop()
		else:
			timer.stop()
			get_node(_timer_node).set_wait_time(fire_delay)
			timer.start()
	
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