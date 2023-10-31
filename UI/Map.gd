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
				get_child(i).modulate = Color(0.102, 0.102, 0.102)
				text[get_child(i).name] = str(get_child(i).name, "\n(Locked)" )
			else:
				get_child(i).modulate = Color(1, 1, 1)
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


func _on_forest_pressed():
	if global.unlocked_map["Forest"]:
		get_tree().change_scene_to_file("res://levels/world.tscn")


func _on_hub_pressed():
	if global.unlocked_map["Hub"]:
		get_tree().change_scene_to_file("res://levels/hub.tscn")


func _on_snow_pressed():
	if global.unlocked_map["Snow"]:
		get_tree().change_scene_to_file("res://levels/snow.tscn")


func _on_city_pressed():
	if global.unlocked_map["City"]:
		get_tree().change_scene_to_file("res://levels/city.tscn")


func _on_desert_pressed():
	if global.unlocked_map["Desert"]:
		get_tree().change_scene_to_file("res://levels/desert.tscn")
