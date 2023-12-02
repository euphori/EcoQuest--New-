extends Node

var time = 0
var seconds = 0
var minutes = 0
var hour = 0

var finish = false
var player_id
var new_lb = {}
var started = false
var score_save_path = "user://highscore.txt"
var leaderboard = [
	{"Name" : "player", "Time": 35},
	{"Name" : "player2", "Time": 350},
	{"Name" : "pX", "Time": 90},
	{"Name" : "wew", "Time": 12},
]
var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

@onready var player = get_parent().get_node("CharacterManager/Kid")

var player_name
# Called when the node enters the scene tree for the first time.
func _ready():
	global.in_dialogue = true
	player.JUMP_VELOCITY += 1.5


func _input(event):
	if event.is_action_pressed("esc"):
		$Pause.visible = !$Pause.visible
		if $Pause.visible:
			global.in_dialogue = true
		else:
			global.in_dialogue = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Timer.is_stopped():
		$Countdown.text = str(int($Timer.time_left))
	if !finish and started and !global.in_dialogue:
		seconds += delta
		time += delta
	if int(seconds) == 60:
		seconds = 0 
		minutes += 1
	if minutes == 60:
		minutes = 0
		hour += 1
	$Label.text = str("%02d:%02d:%02d" % [hour, minutes, seconds])


func gen_unique_string(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result


func save_leaderboard():
	var save_data = {
	"leaderboard" : leaderboard
	}
	var file = FileAccess.open(score_save_path, FileAccess.WRITE)
	var jstr = JSON.stringify(save_data)
	file.store_line(jstr)
	file.close()
	
func load_leaderboard():
	if FileAccess.file_exists(score_save_path):
			var file = FileAccess.open(score_save_path, FileAccess.READ)
			if not file:
				return
			if file == null:
				return
			if FileAccess.file_exists(score_save_path) == true:
				var json = JSON.new()
				json.parse(file.get_as_text())
				var data = json.get_data()
				leaderboard = data["leaderboard"]
				file.close()
	else:
		print("no data saved")


func sort_desc(a,b):
	if a["Time"] < b["Time"]:
		return true
	return false

func initialize_lb():
	$Highscore/Highscores.text = ""
	load_leaderboard()
	var new_id = gen_unique_string(8)
	leaderboard.append({"Name":player_name,"Time":time})
	save_leaderboard()
	var time_scores 
	var names 
	leaderboard.sort_custom(sort_desc)
	for i in leaderboard.size():
		time_scores = format_time(leaderboard[i]["Time"])
		names = leaderboard[i]["Name"]
		$Highscore/Highscores.text += str(i+1, " - ", time_scores,"          ",names ,  "\n")
	

			
		
		
func format_time(val):
	var score = int(val)
	var sc = score % 60
	score /= 60
	var min = score % 60
	score /= 60
	var hr = score
	score = str("%02d:%02d:%02d" % [hr, min, sc])
	return score

func _on_player_detection_body_entered(body):
	body.can_move = false
	$Results.visible = true
	$Results/Time.text = str("%02d:%02d:%02d" % [hour, minutes, seconds])
	leaderboard.sort_custom(sort_desc)
	$Results/Highscore.text = str("Highscore - ",format_time(leaderboard[0]["Time"]))
	finish = true


func _on_texture_button_pressed():
	$Results.visible = false
	if $Results/LineEdit.text != "" or $Results/LineEdit.text != null:
		player_name = $Results/LineEdit.text
	else:
		player_name = "Player"
	leaderboard.sort_custom(sort_desc)
	
	$Highscore.visible = true
	initialize_lb()


func _on_restart_button_pressed():
	global.next_scene = "res://levels/arcade.tscn"
	var loading_screen = load("res://UI/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)


func _on_start_pressed():
	
	$Instructions.visible = false
	$Timer.start(4)


func _on_timer_timeout():
	$Countdown.visible = false
	started = true
	$Label.visible = true
	global.in_dialogue = false



func _on_exit_button_pressed():
	
	global.next_scene = "res://levels/menu_screen.tscn"
	var loading_screen = load("res://UI/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)


func _on_resume_pressed():
	$Pause.visible = false
	global.in_dialogue = false
