extends Node3D


@onready var camera = $Camera3D
@onready var z_slider = $CameraController/ZSlider
@onready var y_slider = $CameraController/YSlider
@onready var x_slider = $CameraController/XSlider
@onready var z_label = $CameraController/ZSlider/Label
@onready var x_label = $CameraController/XSlider/Label2
@onready var y_label = $CameraController/YSlider/Label3

# Called when the node enters the scene tree for the first time.
func _ready():
	z_slider.value = camera.position.z
	x_slider.value = camera.position.x
	y_slider.value = camera.position.y
	z_label.text = str(camera.position.z)
	x_label.text = str(camera.position.x)
	y_label.text = str(camera.position.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_h_slider_value_changed(value):
	camera.position.z = value
	z_label.text = str(camera.position.z)


func _on_x_slider_value_changed(value):
	camera.position.x = value
	x_label.text = str(camera.position.x)

func _on_y_slider_value_changed(value):
	camera.position.y = value
	y_label.text = str(camera.position.y)
