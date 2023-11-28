extends Control


@onready var curr_loc = $Location

var text = {"Forest" : "" , "Hub": "" , "Snow" : "", "Desert" :"" , "City" :""}
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func initialize_map():
	for i in get_child_count():
		if get_child(i) is TextureButton:
			if global.unlocked_map[get_child(i).name] == false:
				get_child(i).visible = false
			else:
				get_child(i).visible = true
				text[get_child(i).name] = get_child(i).name
		var marker_pos
		for x in $MarkerLocation.get_child_count():
			if $MarkerLocation.get_child(x).name == global.curr_scene_name:
				print($MarkerLocation.get_child(x).name)
				marker_pos = $MarkerLocation.get_child(x).global_position
				
		
		if marker_pos != null:
			curr_loc.global_position = marker_pos
		




func load_next_scene():
	var loading_screen = load("res://UI/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)
	



func _on_forest_pressed():
	if global.unlocked_map["Forest"]:
		global.next_scene = "res://levels/forest.tscn"
		load_next_scene()


func _on_hub_pressed():
	if global.unlocked_map["Hub"]:
		global.next_scene = "res://levels/hub.tscn"
		load_next_scene()
		


func _on_snow_pressed():
	if global.unlocked_map["Snow"]:
		global.next_scene = "res://levels/snow.tscn"
		load_next_scene()

func _on_city_pressed():
	if global.unlocked_map["City"]:
		global.next_scene = "res://levels/city.tscn"
		load_next_scene()


func _on_desert_pressed():
	if global.unlocked_map["Desert"]:
		global.next_scene = "res://levels/desert.tscn"
		load_next_scene()

