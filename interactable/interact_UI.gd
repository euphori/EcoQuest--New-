extends Node3D

@onready var parent = get_parent()

@export var text_label = ""

@export_enum ("npc","object","movable","pickable") var type: String


var player_near = false

signal talk

func _input(event):
	if event.is_action_pressed("interact") and player_near:
		print("INTERACT")
		if type == "movable":
			if parent.can_move:
				parent.can_move = false
				visible = true
				print("CANT MOVE")
			else:
				parent.can_move = true
				print(parent.can_move)
				visible = false
		elif type == "npc":
			emit_signal("talk")
		elif type == "pickable":
			global.items[parent.item_name] += 1
			parent.queue_free()

func _ready():
	print(type)
	$Label3D.text = text_label
	visible = false



func _on_player_detection_body_entered(_body):
	visible = true
	player_near = true

func _on_player_detection_body_exited(_body):
	visible = false
	player_near = false
	if type == "movable":
		parent.can_move = false




func _on_player_detection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	visible = true
	player_near = true
	


func _on_player_detection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	visible = false
	player_near = false
	parent.can_move = false
	



func _on_detection_area_body_entered(body):
	visible = true
	player_near = true
	
