extends Node3D

@onready var manager = $CharacterManager

# Called when the node enters the scene tree for the first time.
func _ready():
	global.curr_scene = self.scene_file_path
	manager.load_camera()
	if global.completed_quest["tutorial"] and self.name == "world":
		manager.kid.global_position = $Dock.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
