extends Node3D

@onready var manager = $CharacterManager
@onready var scatter = $ProtonScatter

@export var intro_cam_pos : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	global.curr_scene_name = self.name
	global.curr_scene = self.scene_file_path
	global.curr_level = self
	manager.load_camera()
	
	if intro_cam_pos != null:
		play_intro()
	
	if global.last_player_pos[global.curr_scene_name] != "":
		manager.kid.global_position = str_to_var("Vector3" + global.last_player_pos[global.curr_scene_name])
	#global.save(global.save_path["save1"])


func play_intro():
	$CanvasLayer/Label.visible = true
	manager.disable_cam_control = true
	var old_pos = manager.camera.global_position
	manager.camera.global_position = intro_cam_pos
	await get_tree().create_timer(2).timeout
	var tween = get_tree().create_tween()
	await tween.tween_property(manager.camera , "global_position" , old_pos , 5).finished
	$CanvasLayer/Label.visible = false
	manager.disable_cam_control = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
