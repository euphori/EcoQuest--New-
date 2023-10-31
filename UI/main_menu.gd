extends Control


@onready var menu = $Menu
@onready var options = $OptionsTab

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_started:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	pass

func _on_start_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	menu.visible = false
	global.game_started = true
	queue_free()


func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	$Menu.visible = false
	$OptionsTab.visible = true
