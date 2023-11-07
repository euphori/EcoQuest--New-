extends Control

@onready var loc = $Location

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


func _on_desert_mouse_entered():
	loc.text = text.Desert


func _on_city_mouse_entered():
	loc.text = text.City


func _on_snow_mouse_entered():
	loc.text = text.Snow


func _on_hub_mouse_entered():
	loc.text = text.Hub


func _on_forest_mouse_entered():
	loc.text = text.Forest


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

