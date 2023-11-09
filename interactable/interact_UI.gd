extends Node3D

@onready var parent = get_parent()

@export var text_label = ""
@export_enum ("npc","object","movable","pickable","plant","fix","entrance","computer", "travel") var type: String
@export_category("If Entrace:")
@export var next_scene:String
@export_category("Dialogue")
@export var dialogue_resource : DialogueResource
@export var title : String = "start"


@onready var manager = get_tree().get_root().get_child(5).get_node("CharacterManager")

var player_near = false
var dia_started = false
var player


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
	manager.get_nearest_interactable()
	if manager.nearest_interactable == parent and player_near:
	
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
				manager.interactables.erase(parent)
				parent.queue_free()
				#parent.get_node("Sprite3D").visible = false
				#parent.get_node("CollisionShape3D").disabled = true
				
			elif type == "plant":
				emit_signal("grow")
			elif type == "fix":
				if global.items["Wrench"] >= 1:

					get_parent().rotation.x += deg_to_rad(2)
					

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
			elif type == "travel":
				if parent.name == "Moped":
					manager.journal.map.initialize_map()
					manager.journal.show_map()
				else:
					manager.journal.map.initialize_map()
					manager.journal.show_map()
				global.last_player_pos[global.curr_scene_name] = str(player.global_position)

				

				


func end_dialogue():
	dia_started = false

func _on_player_detection_body_entered(_body):
	player = _body
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
	
