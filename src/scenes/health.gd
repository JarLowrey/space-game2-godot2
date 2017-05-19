extends Node

var health setget set_health
var max_health setget set_max_health

var _bar = null
var _entity = null
var _decrease_hp_anim = null
var _animation_player = null
var health_dec_anim_len = 1

func set_max_health(val):
	max_health = val
	if max_health < health:
		health = max_health

func set_health(val):
	health = val
	if health > max_health:
		max_health = health
	if _bar:
		_bar.set_val(health / max_health)

func animate_health_change(start_hp,end_hp):
	_decrease_hp_anim.track_remove_key (0, 0)
	_decrease_hp_anim.track_remove_key (0, 0)
	_decrease_hp_anim.track_insert_key(0, 0, start_hp)
	_decrease_hp_anim.track_insert_key(0, health_dec_anim_len, end_hp)
	_animation_player.play("DecHealth")

func damage(amt):
	health -= amt

	if health <= 0:
		_entity.kill()

func _ready():
	_bar = get_node("../HealthBar")
	_entity = get_parent()
	_animation_player = get_node("AnimationPlayer")
	
	_decrease_hp_anim = Animation.new()
	_decrease_hp_anim.set_length(health_dec_anim_len)
	_decrease_hp_anim.add_track(Animation.TYPE_VALUE)
	_decrease_hp_anim.track_set_path(0, "HealthBar:range/value")
	_animation_player.add_animation("DecHealth", _decrease_hp_anim)

	pass
