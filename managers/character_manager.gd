extends Node3D


@export var adjust_camera_pos:Vector3


@onready var camera = $Camera3D
@onready var kid = $Kid
@onready var z_slider = $Widgets/CameraController/ZSlider
@onready var y_slider = $Widgets/CameraController/YSlider
@onready var x_slider = $Widgets/CameraController/XSlider
@onready var z_label = $Widgets/CameraController/ZSlider/Label
@onready var x_label = $Widgets/CameraController/XSlider/Label2
@onready var y_label = $Widgets/CameraController/YSlider/Label3
@onready var health_ui = $UI/Health/TextureProgressBar

@onready var quest_tracker = $UI/Quest/QuestInfo
@onready var pause_menu = $UI/PauseMenu

var location = global.curr_scene
var new_camera_offset = {"x":0.5,"y":4,"z":7}
var old_camera_offset = {"x":0.5,"y":4,"z":7}
var start_cam_pos 
var camera_settings
var change_offset_dur = 1
var in_cutscene = false
var curr_quest 
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
	update_quest()
	kid.connect("player_dead", show_death_screen)
	global.connect("update_quest", update_quest)
	
	camera.position += adjust_camera_pos
	health_ui.value = kid.HEALTH
	
	z_slider.value = old_camera_offset["z"]
	x_slider.value = old_camera_offset["x"]
	y_slider.value = old_camera_offset["y"]
	z_label.text = str(old_camera_offset["z"])
	x_label.text = str(old_camera_offset["x"])
	y_label.text = str(old_camera_offset["y"])
	start_cam_pos = old_camera_offset


func _input(event):
	if event.is_action_pressed("esc"):
		if !$Journal.visible and !$Journal/Map.visible:
			show_pause_menu()
			$Journal.visible = false
		else:
			$Journal.visible = false
			$Journal/Map.visible = false


func update_quest():
	for i in global.active_quest:
		if global.active_quest[i] == true:
			curr_quest = i
			var mat = global.req_materials[i][0]
			var req_quant = global.req_materials[i][1]
			var curr_quant
			for x in global.items:
				if x == mat:
					curr_quant = global.items[x]
			var type = global.quest_type[curr_quest]
			quest_tracker.text = str(type , " ", mat , " " , curr_quant , "/" , req_quant)
			if global.req_materials[curr_quest][1] <= global.items[mat]:
				quest_tracker.text = "Talk to NPC"
	if !global.active_quest["tutorial"] and global.completed_quest["tutorial"]:
		if get_parent().name == "Hub":
			quest_tracker.text = "Talk to the farmer"
		else:
			quest_tracker.text = "Travel to the Hub"
	

func show_death_screen():
	$UI/DeathScreen.visible = true

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



func show_pause_menu():
	if !pause_menu.visible:
		pause_menu.visible = true
		var tween = get_tree().create_tween()
		await tween.tween_property(pause_menu , "global_position", Vector2(0,0), 0.3)
	elif pause_menu.visible:
		var tween = get_tree().create_tween()
		tween.tween_property(pause_menu , "global_position", Vector2(0,921), 0.3)
		pause_menu.visible = false

func _on_print_button_pressed():
	print(old_camera_offset)


func _on_restart_pressed():
	global.load_save(global.save_path["save1"])


func _on_quit_pressed():
	get_tree().change_scene_to_packed(load("res://levels/menu_screen.tscn"))
	

func _on_resume_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(pause_menu , "global_position", Vector2(0,921), 0.3)
	pause_menu.visible = false



func _on_load_button_pressed():
	global.load_save(global.save_path["save1"])

func _on_quit_button_pressed():
	get_tree().quit()




func _on_save_progress_button_pressed():
	global.save(global.save_path["save1"])
