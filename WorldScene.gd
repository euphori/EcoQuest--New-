extends Node3D

@onready var manager = $CharacterManager
@onready var scatter = $ProtonScatter


# Called when the node enters the scene tree for the first time.
func _ready():
	global.curr_scene_name = self.name
	global.curr_scene = self.scene_file_path
	manager.load_camera()
	
	if global.last_player_pos[global.curr_scene_name] != "":
		manager.kid.global_position = str_to_var("Vector3" + global.last_player_pos[global.curr_scene_name])
	#global.save(global.save_path["save1"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
