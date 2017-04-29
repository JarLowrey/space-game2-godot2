extends Sprite

var occluder = null
var texture_mapping_json = null

const normal_map_path = "res://assets/normal_maps/"
const normal_map_ext = "_n.png"
const polygon_path = "res://assets/polygon2Ds/"
const polygon_ext = ".xml"

func set_texture(name):
	set_texture(name)
	set_special_stuff()

func map_file_name(texture_name):
	return texture_mapping_json[texture_name]

func set_normal_map(texture_name):
	#load the normal map if it exists
	var normal_map_png_path = normal_map_path + map_file_name(texture_name) + normal_map_ext
	if File.new().file_exists(normal_map_png_path):
		get_material().set_shader_param("normal", load(normal_map_png_path))

func set_occluder_polygon2D(texture_name):
	#load the normal map if it exists
	var polygon_file_path = polygon_path + map_file_name(texture_name) + polygon_ext
	if File.new().file_exists(polygon_file_path):
		print(load(polygon_file_path))
		occluder.get_occluder_polygon().set_polygon(load(polygon_file_path)) ##It's a packed scene, needs to be a Vector2Array

func set_special_stuff():
	var texture_name = get_texture().get_name()
	if texture_name == null or texture_name.length() == 0: #exit if no texture assigned
		return
	var name_minus_extension = texture_name.split(".")[0]
	
	set_normal_map(name_minus_extension)
	set_occluder_polygon2D(name_minus_extension)

func _ready():
	#set up class vars
	var file = File.new()
	file.open("res://assets/json/texture_maps.json",File.READ)
	texture_mapping_json = {}
	texture_mapping_json.parse_json(file.get_as_text())
	occluder = get_node("LightOccluder2D")
	
	set_special_stuff()
	pass
