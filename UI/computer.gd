extends Control

@onready var passwd = $Shutdown/TextEdit
@onready var load_prog = $Loading/TextureProgressBar

var done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	show_screen("MainMenu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_screen(_screen):
	for i in get_child_count():
		if get_child(i).name == _screen:
			get_child(i).visible = true
		elif get_child(i).name == "Background" or get_child(i).name == "Rect" :
			get_child(i).visible = true
		else:
			get_child(i).visible = false
	

func _input(event):
	if event.is_action_pressed("esc"):
		if done:
			self.visible = false
		elif $MainMenu.visible:
			self.visible = false
		else:
			show_screen("MainMenu")

func _on_logs_pressed():
	show_screen("Logs")


func _on_manual_pressed():
	show_screen("Manual")


func _on_shutdown_pressed():
	show_screen("Shutdown")



func _on_text_edit_text_submitted(new_text):
	if passwd.text == "eco" or passwd.text == "ECO":
		show_screen("Loading")
		load_prog.value = 0
		$Background/Label.visible = false
		while  load_prog.value < 100:
			await get_tree().create_timer(0.2).timeout
			load_prog.value += randi_range(1,10)
		if load_prog.value == 100:
			done = true
			global.quest["chapter4"]["q5"].completed == true
			global.quest["chapter4"]["q5"].active == false
			global.quest["chapter4"]["q6"].active == true
			global.emit("update_quest")
			show_screen("ShutdownComplete")
			
			
			
