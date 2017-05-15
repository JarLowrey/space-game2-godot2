extends Sprite

var texture_mapping_json = null

const json_map = "res://assets/json/texture_maps.json"
const polygon_path = "res://assets/godot/scenes/polygon2Ds/"
const polygon_ext = ".xml"

func map_file_name(texture_name):
	return texture_mapping_json[texture_name]

func get_saved_polygon(texture_name):
	#load the normal map if it exists
	var polygon_file_path = polygon_path + map_file_name(texture_name) + polygon_ext
	if File.new().file_exists(polygon_file_path):
		return load(polygon_file_path).instance().get_polygon()
	return null

func set_texture(tex):
	.set_texture(tex)
	var tex = get_texture().get_name().split(".")[0] #remove ext from name
	var collider = get_node("../collider")
	collider.set_polygon(get_saved_polygon(tex))

func _ready():
	#set up class vars
	var file = File.new()
	file.open(json_map,File.READ)
	texture_mapping_json = {}
	texture_mapping_json.parse_json(file.get_as_text())
	
	set_texture(load("res://assets/imgs/ships/enemyGreen1.png"))
	pass