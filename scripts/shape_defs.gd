extends Sprite

# class member variables go here, for example:
# var a = 2
const imgs_path = "res://assets/imgs/"
const normals_path = "res://assets/normal_maps/"
const vertex_path = "res://assets/json/vertices.json"

var sprites = {}

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
	
func create_normal_map(normal_png_path):
	var shader = Shader.new()
	var shader_fragment_code = "uniform texture normal;/*normal maps expect Y-up, but 2D is Y-down, so must mirror this.*/NORMAL = tex(normal,UV).rgb * vec3(2.0,-2.0,1.0) - vec3(1.0,-1.0,0.0);"
	shader.set_code("",shader_fragment_code,"")
	
	var material = CanvasItemMaterial.new()
	material.set_shader(shader)
	material.set_shader_param("NORMAL",load(normal_png_path))
	return material

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
#	#load vertices
	var file = File.new()
	file.open(vertex_path,File.READ)
	var game_data = {}
	game_data.parse_json(file.get_as_text())
#	
#	var imgs = list_files_in_directory(imgs_path)
#	var normal_maps = list_files_in_directory(normals_path)
#	for file_name in imgs:
#		var file_no_ext = file_name.split(".")[0]
#		var normal_map_png_path = normals_path +file_no_ext+"_n.png"
#				
#		var sprite = Sprite.new()
#		sprite.set_texture(load(imgs_path+file_name))
#
#		if file.file_exists(normal_map_png_path):
#			print(file_name)
#			sprite.add_child(create_normal_map(normal_map_png_path))
#		if game_data.has(file_no_ext):
#			print("asd")
#		sprites[file_no_ext] = sprite

	var texture_name = get_texture().get_name()
	var texture_minus_ext = texture_name.split(".")[0]
	var normal_map_png_path = normals_path + texture_minus_ext + "_n.png"
	if file.file_exists(normal_map_png_path):
		var normal_material = create_normal_map(normal_map_png_path)
		set_material(normal_material)
	

	if game_data.has(texture_minus_ext):
		var polygon = get_polygon(game_data[texture_minus_ext])
		
		var collider = CollisionPolygon2D.new()
		collider.set_polygon(polygon)
		add_child(collider)		
		
		var occluder_polygon = OccluderPolygon2D.new()
		occluder_polygon.set_polygon(polygon)
		occluder_polygon.set_cull_mode(occluder_polygon.CULL_COUNTER_CLOCKWISE)
#		occluder_polygon.set_cull_mode(occluder_polygon.CULL_CLOCKWISE)
		var occluder = LightOccluder2D.new()
		occluder.set_occluder_polygon(occluder_polygon)
		occluder.set_blend_mode(BLEND_MODE_ADD)
		add_child(occluder)
		
#	var polygon = Vector2Array()
#	var end = 100
#	polygon.append(Vector2(end,end))
#	polygon.append(Vector2(-end,end))
#	polygon.append(Vector2(-end,-end))
#	polygon.append(Vector2(end,-end))
	pass
	

func get_polygon(pe_data): #physics editor data
	var polygon = Vector2Array()
	print(pe_data)
	return polygon