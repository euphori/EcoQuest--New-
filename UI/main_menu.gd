extends Control


@onready var menu = $Menu
@onready var options = $OptionsTab

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	pass

func _on_start_pressed():
	menu.visible = false
	queue_free()


func _on_quit_pressed():
	get_tree().quit()


func _on_options_pressed():
	$Menu.visible = false
	$OptionsTab.visible = true
