extends Control


@export var albedo = {"hot" : Color(), "warm" : Color(), "fresh" : Color()}
@export var start_val: int

@onready var slider = $CanvasLayer/HSlider
@onready var tree_manager = get_parent().get_node("Tree")
@onready var env = get_parent().get_node("WorldEnvironment")
@onready var terrain  = get_parent().get_node("Terrains")
@onready var vegetation = get_parent().get_node("Vegetation")
@onready var particles = get_parent().get_node("Particles")
@onready var big_tree = get_parent().get_node("BigTree")
var val = 0

var can_grow = false
var grass_multi_mesh = []

var grass_mesh 
func _ready():
	global.connect("update_quest" , update_all)
	update_all()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if check_grass()!= null:
		update_grass(global.env_condition)


func update_all():
	update_trees(global.env_condition)
	#update_sky(start_val)
	update_plants(global.env_condition)
	if is_instance_valid(big_tree):
		update_big_tree(global.env_condition)
	if is_instance_valid(particles):
		update_particles(global.env_condition)
	if is_instance_valid(get_parent().get_node("Rain")):
		var rain = get_parent().get_node("Rain")
		var rand = randi_range(0,3)
		if global.env_condition > 50:
			if rand >= 1:
				rain.visible = true
			else:
				rain.visible = false
		elif global.env_condition <= 50:
			if rand == 1:
				rain.visible = true
			else:
				rain.visible = false


func update_trees(value):
	if tree_manager != null:
		for i in tree_manager.get_child_count():
			if tree_manager.get_child(i) is StaticBody3D and !tree_manager.get_child(i).start_as_seed:
				var rand = randi_range(0,value + 1)
				if rand <= 10 and value < 98:
					tree_manager.get_child(i).curr_state = "bald"
					tree_manager.get_child(i).update_state()
				elif rand >= 11 and rand <= 70 and  value < 98:
					tree_manager.get_child(i).curr_state = "trim"
					tree_manager.get_child(i).update_state()
				elif rand > 70:
					tree_manager.get_child(i).curr_state = "full"
					tree_manager.get_child(i).update_state()
				elif value >= 98:
					tree_manager.get_child(i).curr_state = "full"
					tree_manager.get_child(i).update_state()
				await get_tree().create_timer(.01).timeout
	else:
		print("Tree Manager Doesn't Exist")




func update_plants(value):
	if terrain != null:
		for i in terrain.get_child_count():
			var plain = terrain.get_child(i)
			if plain is MeshInstance3D:
				for x in terrain.get_child(i).get_child_count():
					var plants = plain.get_child(x)
					if plants is MultiMeshInstance3D:
						#plants.multimesh.visible_instance_count = value
						var tween = get_tree().create_tween()
						var num_of_plants = plants.multimesh.instance_count * (value/100)
						if num_of_plants <= 0:
							num_of_plants = 3
						tween.tween_property(plants.multimesh, "visible_instance_count", num_of_plants, 3)
	else:
		print("Terrain Node doesn't exist")


func update_sky(value):
	#Color(0.71, 0.322, 0.075) WARM
	#Color(0.443, 0.467, 0.329) MID
	
	#EMISSION
	##Color(0.078, 0.161, 0.149) COOL
	#Color(0.185, 0.135, 0.026) WARM
	#Color(0.185, 0.135, 0.026) MID
	var tween = get_tree().create_tween()
	if env != null:
		if value > 65:
			tween.tween_property(env.environment,"volumetric_fog_albedo", albedo["fresh"], 3)
			tween.tween_property(env.environment,"volumetric_fog_emission", Color(0.078, 0.161, 0.149), 3)
		elif value < 65 and value > 30:
			tween.tween_property(env.environment,"volumetric_fog_albedo", albedo["warm"], 3)
			tween.tween_property(env.environment,"volumetric_fog_emission", Color(0.185, 0.135, 0.026), 3)
		else:
			tween.tween_property(env.environment,"volumetric_fog_albedo", albedo["hot"], 3)
			tween.tween_property(env.environment,"volumetric_fog_emission", Color(0.185, 0.135, 0.026), 3)
	else:
		print("Evironment not found!")


func check_grass():
	if is_instance_valid(vegetation):
		for x in vegetation.get_child_count():
			var _vegetation = vegetation.get_child(x)
			var scatter_item = _vegetation.get_node("ScatterOutput").get_node("ScatterItem")
			if is_instance_valid(scatter_item):
				for y in scatter_item.get_child_count():
					return scatter_item.get_child(y)
			else:
				return null
	else:
		return null

func update_grass(value):
	for x in vegetation.get_child_count():
		var _vegetation = vegetation.get_child(x)
		vegetation.get_child(x).show_output_in_tree = true
		var scatter_item = _vegetation.get_node("ScatterOutput").get_node("ScatterItem")
		if is_instance_valid(scatter_item):
			for y in scatter_item.get_child_count():
				var item = scatter_item.get_child(y)
				var percent = float(float(value) / 100)
				var tween = get_tree().create_tween()
				tween.tween_property(item.multimesh, "visible_instance_count" ,  abs(item.multimesh.instance_count * percent) , 5)
			#item.multimesh.visible_instance_count = abs(item.multimesh.instance_count * percent)
	

func update_particles(value):
	for i in particles.get_child_count():
		var _particles = particles.get_child(i)
		if value > 80:
			_particles.visible = true
		else:
			_particles.visible = false

func update_big_tree(value):
	var particle = big_tree.get_node("FallingLeaves")
	var leaves = big_tree.get_node("Leaves")
	if value > 70:
		particle.visible = true
		leaves.visible = true
	else:
		particle.visible = false
		leaves.visible = false

func update_terrain(value):
	for i in terrain.get_child_count():
		var _terrain = terrain.get_child(i)
		if value <= 25:
			_terrain.material_override.albedo_color = Color(0.745, 0.373, 0)
		elif value > 25 and value <= 75:
			_terrain.material_override.albedo_color = Color(0.612, 0.643, 0.576)
		else:
			_terrain.material_override.albedo_color = Color(0.78, 0.78, 0.78)


func _on_h_slider_value_changed(value):
	global.env_condition = value
	val = value
	$CanvasLayer/Label.text = str(val)
	update_trees(value)
	#update_sky(value)
	update_grass(value)
	update_plants(value)
	if is_instance_valid(particles):
		update_particles(value)
	if is_instance_valid(big_tree):
		update_big_tree(value)

