extends Control

@export_category("Player Paths")
@export var path_to_kid:NodePath
@export var path_to_robot:NodePath


@onready var input_line = $LineEdit
@onready var history = $TextEdit
@onready var kid = get_node(path_to_kid)
@onready var widget = get_parent().get_node("Widgets")
@onready var env_controller = get_parent().get_parent().get_node("EnvController/CanvasLayer")

var commands = {
	"speed":"speed",
	"fps":"fps",
	"camera":"camera",
	"stats" : "stats",
	"comp" : "comp",
	"act" : "act",
	"help" : "help",
	"clear" : "clear",
	"collision" : "collision",
	"env" : "env",
	"add" : "add",
	"unlock" : "unlock",
	"hesoyam" : "hesoyam",
	"green" : "green",
	"compall" : "compall"
	
	
	}
	
var is_console_visible = false
var is_first_key_pressed = false


func _ready():
	input_line.editable = false
	set_process_input(true)


func _input(event):
	
	if event.is_action_pressed("console"):
		is_console_visible = !is_console_visible
		if visible:
			visible = false
			kid.can_move = true
			get_parent().journal_icon.visible = true
		else:
			visible = true
			kid.can_move = false
			get_parent().journal_icon.visible = false
		if is_console_visible:
			input_line.editable = true
			input_line.grab_focus()
		
		
			
# Called when the node enters the scene tree for the first time.




func apply_command(comm,value1, value2):
	if comm == commands["speed"]:
		kid.SPEED = float(value1)
	elif comm == commands["fps"]:
		widget.fps.visible = !widget.fps.visible
			
	elif comm == commands["camera"]:
		widget.camera_controller.visible = !widget.camera_controller.visible 
	elif comm == commands["stats"]:
		if value1 == "kid":
			widget.kid_stats.visible = !widget.kid_stats.visible
		else:
			widget.kid_stats.visible = !widget.kid_stats.visible
	elif comm == commands["comp"]:
		for i in global.quest:
			if i == value1:
				for x in global.quest[i]:
					if x == value2:
						global.quest[i][x].active = false
						global.quest[i][x].completed = true
						global.emit_signal("update_quest")
						break
	elif comm == commands["act"]:
		for i in global.quest:
			if i == value1:
				for x in global.quest[i]:
					if x == value2:
						global.quest[i][x].active = true
			
				global.emit_signal("update_quest")
	elif comm == commands["help"]:
		history.text += str("List of Commands: ","\n")
		for i in commands:
			history.text += str("-",commands[i],"\n")
	elif comm == commands["clear"]:
		history.clear()
	elif comm == commands["collision"]:
		get_tree().set_debug_collision_hint(true)
	elif comm == commands["env"]:
		env_controller.visible =  !env_controller.visible
	elif comm == commands["add"]:
		if value1 and !value2:
			for i in global.items:
				if i == value1:
					global.items[i] += 5
		elif value1 and value2:
			for i in global.items:
				if i == value1:
					global.items[i] += str_to_var(value2)
		global.emit_signal("item_added")
	elif comm == commands["unlock"]:
		if value1:
			
			for i in global.unlocked_map:
				if value1 == "all":
					global.unlocked_map[i] = true
				if i == value1:
					global.unlocked_map[i] = true
	elif comm == commands["hesoyam"]:
		kid.can_die = false
	elif comm == commands["green"]:
		global.env_condition = str_to_var(value1)
	elif comm == commands["compall"]:
		for quests in global.quest[value1]: #get the quests in the entered chapter
			global.quest[value1][quests].completed = true
				

func _on_line_edit_text_submitted(new_text):
	history.text += str(new_text,"\n")

	var parts = new_text.split(" ")
	if parts.size() == 2:
		var value1 = parts[1]

		if commands.has(parts[0]):
			apply_command(parts[0],parts[1], "")
		else:
			history.text += "command not found\n"
	elif parts.size() == 3:
		var value1 = parts[1]
		var value2 = parts[2]
		if commands.has(parts[0]):
			apply_command(parts[0],parts[1],parts[2])
		else:
			history.text += "command not found\n"
	else:
		if commands.has(parts[0]):
			apply_command(parts[0],"","")
		else:
			history.text += "command not found\n"
	input_line.clear()
	






func _on_line_edit_text_changed(new_text):
	if new_text == "`":
		input_line.clear()
	
