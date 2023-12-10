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
	if event.is_action_pressed("esc") and $OptionsTab.visible:
		$OptionsTab.visible = false
		$Menu.visible = true

func _on_start_pressed():
	global.next_scene = "res://levels/presurvey.tscn"
	global.load_player_id()
	global.player_id += 1
	global.save_player_id()
	
	var loading_screen = load("res://UI/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)


func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	
	$Menu.visible = false
	$OptionsTab.visible = true


func _on_resume_pressed():
	global.load_save(global.save_path["save1"])
