extends Node3D


@export var path_to_manager: NodePath
@export var camera_offset : String
@export var change_offset_dur : float

@onready var player_manager = get_node(path_to_manager)


var player
var old_offset
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_body_entered(body):
	if body.is_in_group("player"):
		player = body
		old_offset = player_manager.old_camera_offset
		var new_offset = JSON.parse_string(camera_offset)
		player_manager.change_offset(new_offset , change_offset_dur)


func _on_start_body_exited(body):
	if body.is_in_group("player"):
		player_manager.change_offset(old_offset , change_offset_dur)

