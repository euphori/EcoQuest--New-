extends Node3D


@export var dialogue_resource: DialogueResource
@export var title : String = "start"

@export var player_manager: Node3D
@onready var marker = $Marker3D
@onready var marker_sprite = $Marker3D/Sprite3D
@export var player : CharacterBody3D

@export_category("Quest Requirement")
@export var chapter_name : String = ""
@export var completed_quest: String = ""
@export var active_quest: String = ""
 
var old_camera_pos
var dia_started = false

func _ready():
	global.connect("update_quest" , play_cutscene)
	GlobalDialogue.connect("dialogue_ended_cutscene", finish_cutscene)
	marker_sprite.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_dialogue():
	dia_started = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)
	

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
		global.in_dialogue = false
	if dialogue_resource != null and !dia_started:
		global.in_dialogue = true
		show_dialogue()


func play_cutscene():
	if  completed_quest != "" and chapter_name != "":
		if global.quest[chapter_name][completed_quest].completed:
			player.can_move = false 
			player_manager.disable_cam_control = true
			player_manager.in_cutscene = true
			old_camera_pos = player_manager.camera.global_position 
			pan_camera(marker.global_position)
	elif chapter_name != "" and active_quest != "":
		if global.quest[chapter_name][active_quest].active:
			player.can_move = false 
			player_manager.disable_cam_control = true
			player_manager.in_cutscene = true
			old_camera_pos = player_manager.camera.global_position 
			pan_camera(marker.global_position)
	else:
		player.can_move = false 
		player_manager.disable_cam_control = true
		player_manager.in_cutscene = true
		old_camera_pos = player_manager.camera.global_position 
		pan_camera(marker.global_position)
			

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		play_cutscene()
		
