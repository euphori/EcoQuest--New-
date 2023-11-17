extends Node3D

@onready var manager = $CharacterManager
@onready var map_label = $CanvasLayer/Label
@onready var intro_anim = $CanvasLayer/AnimationPlayer

@export var map_name : String
@export var intro_cam_pos : Vector3
@export var _play_intro = true

var old_pos 
# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "Hub":
		var rand = randi_range(0,2)
		print(rand)
		if rand == 1:
			$DirectionalLight3D2.visible = true
			$DirectionalLight3D.visible = false
		else:
			$DirectionalLight3D2.visible = false
			$DirectionalLight3D.visible = true
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
	if map_label != null and map_label.text != "" and _play_intro:
		
		$Camera3D.global_position = intro_cam_pos
		$Camera3D.current = true
		map_label.text = map_name
		intro_anim.play("label_fade_in")
		await get_tree().create_timer(1.5).timeout
		intro_anim.play("label_fade_out")
		await intro_anim.animation_finished
		return_camera()
		
	

func return_camera():
	var tween = get_tree().create_tween()
	await tween.tween_property($Camera3D , "global_position" , old_pos ,1.5).finished
	manager.camera.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
