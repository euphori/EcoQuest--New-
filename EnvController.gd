extends Control


@export var albedo = {"hot" : Color(), "warm" : Color(), "fresh" : Color()}


@onready var slider = $CanvasLayer/HSlider
@onready var tree_manager = get_parent().get_node("Tree")
@onready var env = get_parent().get_node("WorldEnvironment")
@onready var terrain  = get_parent().get_node("Terrains")



var val = 0


func _ready():
	update_trees()
	update_sky(0)
	update_plants(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_trees():
	if tree_manager != null:
		for i in tree_manager.get_child_count():
			if tree_manager.get_child(i) is StaticBody3D and !tree_manager.get_child(i).start_as_seed:
				var rand = randi_range(0,val + 1)
				if rand < 10 and val < 70 and  val < 98:
					tree_manager.get_child(i).curr_state = "bald"
					tree_manager.get_child(i).update_state()
				elif rand > 11 and rand < 70 and  val < 98:
					tree_manager.get_child(i).curr_state = "trim"
					tree_manager.get_child(i).update_state()
				elif rand > 70:
					tree_manager.get_child(i).curr_state = "full"
					tree_manager.get_child(i).update_state()
				elif val >= 98:
					tree_manager.get_child(i).curr_state = "full"
					tree_manager.get_child(i).update_state()
	else:
		print("Tree Manager Doesn't Exist")




func update_plants(value):
	if terrain != null:
		for i in terrain.get_child_count():
			var plain = terrain.get_child(i)
			if plain is MeshInstance3D:
				print(plain)
				for x in terrain.get_child(i).get_child_count():
					var plants = plain.get_child(x)
					if plants is MultiMeshInstance3D:
						#plants.multimesh.visible_instance_count = value
						var tween = get_tree().create_tween()
						var num_of_plants = plants.multimesh.instance_count * (value/100)
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


func _on_h_slider_value_changed(value):
	val = value
	$CanvasLayer/Label.text = str(val)
	update_trees()
	update_sky(value)
	update_plants(value)

