extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	GlobalDialogue.connect("dialogue_ended", next_scene)
	

func next_scene():
	var loading_screen = load("res://UI/loading_screen.tscn")
	global.next_scene = "res://levels/forest.tscn"
	get_tree().change_scene_to_packed(loading_screen)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_story_button_pressed():
	DialogueManager.show_dialogue_box(load("res://presurvey.dialogue"), "start")
	$Mode.visible = false


func _on_arcade_button_pressed():
	var loading_screen = load("res://UI/loading_screen.tscn")
	global.next_scene = "res://levels/arcade.tscn"
	get_tree().change_scene_to_packed(loading_screen)




func _on_story_button_mouse_entered():
	$Mode/AnimationPlayer.play("hover_story")
	


func _on_story_button_mouse_exited():
	$Mode/AnimationPlayer.play("exit_story")


func _on_arcade_button_mouse_entered():
	$Mode/AnimationPlayer2.play("arcade_hover")
	


func _on_arcade_button_mouse_exited():
	$Mode/AnimationPlayer2.play("arcade_exit")
