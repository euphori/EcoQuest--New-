extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_dialogue_box(load("res://presurvey.dialogue"), "start")
	GlobalDialogue.connect("dialogue_ended", next_scene)
	

func next_scene():
	var loading_screen = load("res://UI/loading_screen.tscn")
	global.next_scene = "res://levels/forest.tscn"
	get_tree().change_scene_to_packed(loading_screen)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
