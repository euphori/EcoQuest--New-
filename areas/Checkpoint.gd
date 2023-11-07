extends Node3D


@export var path_to_player:NodePath

@onready var player = get_node(path_to_player)


var checked = {"Point1" : false }
var last_checkpoint


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_point_1_body_entered(body):
	if body == player:
		global.last_player_pos[global.curr_scene_name] = str(player.global_position)
		global.save(global.save_path["save1"])
		last_checkpoint = get_node("Point1")


func _on_reset_body_entered(body):
	if body == player:
		if last_checkpoint:
			player.global_position = last_checkpoint.global_position


func _on_point_2_body_entered(body):
	if body == player:
		global.last_player_pos[global.curr_scene_name] = str(player.global_position)
		global.save(global.save_path["save1"])
		last_checkpoint = get_node("Point2")
