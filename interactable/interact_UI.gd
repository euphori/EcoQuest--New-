extends Node3D

@onready var parent = get_parent()

@export var text_label = ""
@export_enum ("npc","object","movable","pickable","plant","fix","entrance","computer") var type: String
@export_category("If Entrace:")
@export var next_scene:String
@export_category("Dialogue")
@export var dialogue_resource : DialogueResource
@export var title : String = "start"




var player_near = false
var dia_started = false


signal talk
signal item_added
signal move
signal stop
signal grow



func _ready():
	
	#Dialogue.connect("dialogue_ended_interaction" , end_dialogue)
	$Label3D.text = text_label
	visible = false
func _input(event):

	
	if type == "movable"  and parent.colliding:
		if event.is_action_pressed("interact"):
			emit_signal("move")
			parent.can_move = true
			visible = false
		if event.is_action_released("interact"):
			emit_signal("stop")
			parent.can_move = false
			visible = true

	if event.is_action_pressed("interact") and player_near:
		if type == "npc":
			emit_signal("talk")
			$TalkIcon.visible = false
		elif type == "pickable":
			
			global.items[parent.item_name] += 1
			emit_signal("item_added")
			global.emit_signal("update_quest")
			#await $AudioStreamPlayer.finished
			parent.queue_free()
			
		elif type == "plant":
			emit_signal("grow")
		elif type == "fix":
			if global.items["Wrench"] >= 1:

				get_parent().rotation.x += deg_to_rad(2)
				
				print(get_parent().global_rotation.x)
				if get_parent().rotation.x >= 0:
					global.fixed_pipe = true
					get_parent().get_node("GPUParticles3D").queue_free()
					queue_free()
			else:
				if dialogue_resource != null and !dia_started:

					DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)
					dia_started = true
		elif type == "entrance":
			get_tree().change_scene_to_file(next_scene)
		elif type == "computer":
			parent.visible = !parent.visible
			

			


func end_dialogue():
	dia_started = false

func _on_player_detection_body_entered(_body):
	print("ENTEERED")
	player_near = true
	if type == "plant" and parent.start_as_seed:
		visible = true
	elif type != "plant":
		visible = true
	if type == "npc":
		parent.player_in_range = true
		if !dia_started:
			$TalkIcon.visible = true
		parent.player = _body
		

func _on_player_detection_body_exited(_body):
	visible = false
	player_near = false
	if type == "movable":
		parent.can_move = false
	if type == "npc":
		$TalkIcon.visible = false



func _on_detection_area_body_entered(body):
	visible = true
	player_near = true
	
