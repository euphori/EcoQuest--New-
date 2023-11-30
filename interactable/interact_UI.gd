extends Node3D

@onready var parent = get_parent()

@export var text_label = ""
@export_enum ("npc","object","movable","pickable","plant","fix","entrance","computer", "travel", "observe") var type: String
@export_category("If Entrace:")
@export var next_scene:String
@export var new_player_pos : Vector3
@export var new_offset : String
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
	if type == "npc":
		$Arrow.queue_free()
	visible = false
	
	


func _input(event):

	manager.get_nearest_interactable()
	if manager.nearest_interactable == parent and player_near:
		if event.is_action_pressed("interact"):
			if is_instance_valid($Arrow):
				$Arrow.visible = false
				$Hint.visible = false
		if type == "movable"  and parent.colliding:
			if event.is_action_pressed("interact"):
				emit_signal("move")
				parent.can_move = true
				visible = false
			if event.is_action_released("interact"):
				emit_signal("stop")
				parent.can_move = false
				visible = true

		if event.is_action_pressed("interact" ) and player_near:
			if type == "npc":
				emit_signal("talk")
				$TalkIcon.visible = false
			elif type == "pickable":
				global.items[parent.item_name] += parent.amount
				emit_signal("item_added")
				global.emit_signal("update_quest")
				global.emit_signal("pickup_item", parent.item_name, parent.amount)
				#await $AudioStreamPlayer.finished
				manager.interactables.erase(parent)
				#parent.get_node("Sprite3D").visible = false
				#parent.get_node("CollisionShape3D").disabled = true
				
			elif type == "plant":
				emit_signal("grow")
			elif type == "fix":
				if global.items["Wrench"] >= 1 and global.quest["chapter2"]["q3"].active:
					get_parent().rotation.x += deg_to_rad(2)
					if get_parent().rotation.x >= 0:
						global.fixed_pipe = true
						get_parent().get_node("GPUParticles3D").queue_free()
						global.quest["chapter2"]["q3"].completed = true
						global.quest["chapter2"]["q3"].active = false
						global.emit_signal("update_quest")
						queue_free()
				else:
					if dialogue_resource != null and !dia_started and global.quest["chapter2"]["q3"].active:
						DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)
						dia_started = true
						
			elif type == "entrance":
				if next_scene != null:
					global.save(global.save_path["save1"])
					get_tree().change_scene_to_file(next_scene)
					
			elif type == "computer":
				parent.get_node("Computer").visible = !parent.get_node("Computer").visible
				
			elif type == "travel":
				if parent.name == "Moped" and global.scooter_repaired:
					if parent.need_to_charge and parent.charged:
						manager.journal.map.initialize_map()
						manager.journal.show_map()
					else:
						manager.journal.map.initialize_map()
						manager.journal.show_map()
				elif parent.name == "Moped" and !global.scooter_repaired and parent.has_dialogue:
					parent.show_dialogue()
				else:
					manager.journal.map.initialize_map()
					manager.journal.show_map()
				global.last_player_pos[global.curr_scene_name] = str(player.global_position)
			elif type == "observe":
				if !parent.done:
					parent.observe_bar.visible = true
		


func end_dialogue():
	dia_started = false

func _on_player_detection_body_entered(_body):
	if is_instance_valid($Arrow):
		$Arrow.visible = true
	if is_instance_valid($Exclamation):
		$Exclamation.visible = false
	if _body.is_in_group("player"):
		player = _body
		player_near = true
		if type == "observe" and !global.quest["chapter3"]["q2"].active:
			visible = false
		else:
			visible = true
	if self.visible:
		$Hint.visible = true
		if type == "movable":
			$Hint/Label.text = "Hold ○ to move"
		else:
			$Hint/Label.text = "Press ○ to interact"
		
	
	if type == "npc":
		parent.player_in_range = true
		if !dia_started:
			$TalkIcon.visible = true
		parent.player = _body
		

func _on_player_detection_body_exited(_body):
	if is_instance_valid($Arrow):
		$Arrow.visible = false
	visible = false
	$Hint.visible = false
	player_near = false
	if type == "movable":
		parent.can_move = false
	if type == "npc":
		$TalkIcon.visible = false



