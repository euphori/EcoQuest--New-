extends StaticBody3D

@export_file("*tscn") var next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("interact") and $InteractUI.player_near:
		get_tree().change_scene_to_file(next_scene)
