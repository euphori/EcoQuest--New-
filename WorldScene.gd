extends Node3D

@onready var manager = $CharacterManager
@onready var scatter = $ProtonScatter
@onready var map_label = $CanvasLayer/Label

@export var map_name : String
@export var intro_cam_pos : Vector3

var old_pos 
# Called when the node enters the scene tree for the first time.
func _ready():
	global.curr_scene_name = self.name
	global.curr_scene = self.scene_file_path
	global.curr_level = self
	if intro_cam_pos != null:
		play_intro()
	manager.load_camera()
	old_pos = manager.get_camera_pos()
	
	
	
	if global.last_player_pos[global.curr_scene_name] != "":
		manager.kid.global_position = str_to_var("Vector3" + global.last_player_pos[global.curr_scene_name])
	#global.save(global.save_path["save1"])


func play_intro():
	if map_label != null:
		
		$Camera3D.global_position = intro_cam_pos
		$Camera3D.current = true
		map_label.text = map_name
		map_label.visible = true
		await get_tree().create_timer(1.5).timeout
		map_label.visible = false
		return_camera()
		
	
		

func return_camera():
	var tween = get_tree().create_tween()
	await tween.tween_property($Camera3D , "global_position" , old_pos ,1.5).finished
	manager.camera.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
