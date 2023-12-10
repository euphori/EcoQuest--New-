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
var probability_of_rain = 0.3
var is_raining = false

var can_grow = false
var grass_multi_mesh = []

var grass_mesh 
func _ready():
	global.connect("update_env" , update_all)
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
		var probability_threshold = float(global.env_condition)/100 # Adjust this threshold as needed
		
		var random_values = []  # Array to store random values
		var total_iterations = 1000  # Number of Monte Carlo iterations

		# Generate random values for Monte Carlo simulation
		for i in range(total_iterations):
			random_values.append(randf())

		# Calculate rain visibility based on the Monte Carlo simulation
		var visible_count = 0
		for value in random_values:
			if value < probability_threshold:
				visible_count += 1

		# Set rain visibility based on the proportion of visible iterations
		var visibility_percentage = float(visible_count) / float(total_iterations)
		print(visibility_percentage)
		if visibility_percentage > 0.5:  # Adjust visibility threshold as needed
			rain.visible = true
			rain.get_node("AudioStreamPlayer").play()
		else:
			rain.visible = false


func update_trees(value):
	if tree_manager != null:
		var growth_prob = float(value) / 100  # Probability of tree growth

		for i in tree_manager.get_children():
			if i is StaticBody3D and !i.start_as_seed:
				var rand = randf()  # Random value between 0 and 1
				if rand < growth_prob:  # Using Monte Carlo method to determine growth
					if rand < growth_prob * 0.2:  # Adjust probability thresholds as needed
						i.curr_state = "bald"
					elif rand < growth_prob * 0.7:
						i.curr_state = "trim"
					else:
						i.curr_state = "full"

				i.update_state()

				await get_tree().create_timer(0.5).timeout
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

