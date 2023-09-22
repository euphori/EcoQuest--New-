extends Node3D

@onready var box = get_parent()

@export var text_label = ""

@export_enum ("npc","object","movable") var type: String


var player_near = false

signal talk

func _input(event):
	if event.is_action_pressed("interact") and player_near:
		print("INTERACT")
		if type == "movable":
			if box.can_move:
				box.can_move = false
				visible = true
				print("CANT MOVE")
			else:
				box.can_move = true
				print(box.can_move)
				visible = false
		elif type == "npc":
			emit_signal("talk")
			

func _ready():
	print(type)
	$Label3D.text = text_label
	visible = false



func _on_player_detection_body_entered(body):
	visible = true
	player_near = true

func _on_player_detection_body_exited(body):
	visible = false
	player_near = false
	if type == "movable":
		box.can_move = false




func _on_player_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	visible = true
	player_near = true
	


func _on_player_detection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	visible = false
	player_near = false
	box.can_move = false
	

