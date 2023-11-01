extends Node3D


@export var adjust_camera_pos:Vector3


@onready var camera = $Camera3D
@onready var robot = $Robot
@onready var kid = $Kid
@onready var z_slider = $Widgets/CameraController/ZSlider
@onready var y_slider = $Widgets/CameraController/YSlider
@onready var x_slider = $Widgets/CameraController/XSlider
@onready var z_label = $Widgets/CameraController/ZSlider/Label
@onready var x_label = $Widgets/CameraController/XSlider/Label2
@onready var y_label = $Widgets/CameraController/YSlider/Label3
@onready var health_ui = $UI/Health/TextureProgressBar
@onready var energy_ui = $UI/Energy/TextureProgressBar


var location = global.curr_scene
var new_camera_offset = {"x":4.0,"y":3.0,"z":3.0}
var old_camera_offset = {"x":4.0,"y":3.0,"z":3.0}
var start_cam_pos 
var camera_settings
var change_offset_dur = 1
var in_cutscene = false

var save_path = {
	"res://levels/lab.tscn": "user://lab_camera.txt",
	"res://levels/forest.tscn": "user://forest_camera.txt",
	"res://levels/hub.tscn": "user://hub_camera.txt",
	"res://levels/desert.tscn" : "user://desert_camera.txt",
	"res://levels/snow.tscn": "user://snow_camera.txt",
	"res://levels/city.tscn": "user://city_camera.txt",
	}
var disable_cam_control = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	camera.position += adjust_camera_pos
	health_ui.value = kid.HEALTH
	robot.queue_free()
	
	z_slider.value = old_camera_offset["z"]
	x_slider.value = old_camera_offset["x"]
	y_slider.value = old_camera_offset["y"]
	z_label.text = str(old_camera_offset["z"])
	x_label.text = str(old_camera_offset["x"])
	y_label.text = str(old_camera_offset["y"])
	start_cam_pos = old_camera_offset





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !disable_cam_control:
		var tween = get_tree().create_tween()
		tween.tween_property(camera, "global_position", Vector3(kid.global_position.x + old_camera_offset["x"],kid.global_position.y + old_camera_offset["y"],old_camera_offset["z"]) ,.3)
		#camera.global_position.x = kid.global_position.x + old_camera_offset["x"]
		#camera.global_position.y = kid.global_position.y + old_camera_offset["y"]
		#camera.global_position.z =  old_camera_offset["z"]
	elif !in_cutscene and disable_cam_control:
		var new_cam_pos = Vector3(kid.global_position.x + old_camera_offset["x"],kid.global_position.y + old_camera_offset["y"],old_camera_offset["z"])
		var tween = get_tree().create_tween()
		tween.tween_property(camera, "global_position",new_cam_pos ,change_offset_dur)
		await tween.finished
		disable_cam_control = false

func load_camera():
	if save_path[global.curr_scene] != null:
		load_save(save_path[global.curr_scene])
	z_slider.value = old_camera_offset["z"]
	x_slider.value = old_camera_offset["x"]
	y_slider.value = old_camera_offset["y"]


func _on_z_slider_value_changed(value):
	old_camera_offset["z"] = value
	z_label.text = str(old_camera_offset["z"])


func _on_x_slider_value_changed(value):
	new_camera_offset["x"] = value
	old_camera_offset["x"] = new_camera_offset["x"]
	x_label.text = str(old_camera_offset["x"])


func _on_y_slider_value_changed(value):
	new_camera_offset["y"] = value
	old_camera_offset["y"] = new_camera_offset["y"]
	y_label.text = str(old_camera_offset["y"])





func _on_save_button_pressed():
	save(save_path[global.curr_scene])

func _on_reset_button_pressed():
	load_save(save_path[global.curr_scene])
	z_slider.value = camera.position.z
	x_slider.value = old_camera_offset["x"]
	y_slider.value = old_camera_offset["y"]


func change_offset(value : Dictionary , dur : float):
	disable_cam_control = true
	old_camera_offset = value
	change_offset_dur = dur





func save(_save_path):
	camera_settings = {
		"old_camera_offset" : old_camera_offset,
		"z_position" : camera.position.z
	}
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	
	var jstr = JSON.stringify(camera_settings)
	file.store_line(jstr)
	print(jstr)
	file.close()
	
func load_save(_save_path):
	if FileAccess.file_exists(_save_path):
		var file = FileAccess.open(_save_path, FileAccess.READ)
		if not file:
			return
		if file == null:
			return
		if FileAccess.file_exists(_save_path) == true:
			var json = JSON.new()
			json.parse(file.get_as_text())
			var data = json.get_data()
			print(data)
			old_camera_offset = data.old_camera_offset
			camera.position.z = data.z_position
			
			file.close()
	else:
		print("no data saved")




func _on_print_button_pressed():
	print(old_camera_offset)
