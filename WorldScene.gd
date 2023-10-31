extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	global.curr_scene = self.scene_file_path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
