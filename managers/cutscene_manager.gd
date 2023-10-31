extends Node3D

@export var path_to_manager: NodePath
@export var dialogue : String

@onready var player_manager = get_node(path_to_manager)
@onready var marker = $Marker3D
@onready var marker_sprite = $Marker3D/Sprite3D
var player 
var old_camera_pos
var dia_started = false

func _ready():
	global.connect("dialogue_done", finish_cutscene)
	marker_sprite.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_dialogue():
	dia_started = true
	DialogueManager.show_example_dialogue_balloon(load(dialogue), "start")

func finish_cutscene():
	if player != null:
		await pan_camera(old_camera_pos)
	$PlayerDetection/CollisionShape3D.disabled = true
	player_manager.in_cutscene = false


func pan_camera(_location):
	var tween = get_tree().create_tween()
	tween.tween_property(player_manager.camera,"global_position", _location, 2)
	await tween.finished
	if dia_started:
		player_manager.disable_cam_control = false
		player.can_move = true
	if dialogue != "" and !dia_started:
		show_dialogue()


func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		print("PLAYER DETECTED")
		player = body
		player.can_move = false
		player_manager.disable_cam_control = true
		player_manager.in_cutscene = true
		old_camera_pos = player_manager.camera.global_position 
		pan_camera(marker.global_position)
		
