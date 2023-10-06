extends Node3D


@export var new_camera_offset = {"x":4,"y":3,"z":3}
@export var old_camera_offset = {"x":4,"y":3,"z":3}
@export var player_num = 1


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

# Called when the node enters the scene tree for the first time.
func _ready():
	print(StaticData.item_data)
	if player_num == 1:
		robot.queue_free()
	
	z_slider.value = camera.position.z
	x_slider.value = old_camera_offset["x"]
	y_slider.value = old_camera_offset["y"]
	z_label.text = str(camera.position.z)
	x_label.text = str(old_camera_offset["x"])
	y_label.text = str(old_camera_offset["y"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if kid.active:
		camera.global_position.x = kid.global_position.x + old_camera_offset["x"]
		camera.global_position.y = kid.global_position.y + old_camera_offset["y"]
	else:
		camera.global_position.x = robot.global_position.x
		camera.global_position.y = robot.global_position.y + old_camera_offset["y"]



func _on_z_slider_value_changed(value):
	camera.position.z = value
	z_label.text = str(camera.position.z)


func _on_x_slider_value_changed(value):
	new_camera_offset["x"] = value
	


func _on_y_slider_value_changed(value):
	new_camera_offset["y"] = value
	


func _on_x_slider_drag_ended(value_changed):
	if value_changed:
		old_camera_offset["x"] = new_camera_offset["x"]
		x_label.text = str(old_camera_offset["x"])


func _on_y_slider_drag_ended(value_changed):
	if value_changed:
		old_camera_offset["y"] = new_camera_offset["y"]
		y_label.text = str(old_camera_offset["y"])


