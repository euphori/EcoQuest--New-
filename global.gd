extends Node

@onready var player
var player_pos

var save_path = {"save1" : "user://save1.txt", "save2" : "user://save2.save", "save3" : "user://save3.save" }
var curr_scene
var save_database 

var questStart = false
var game_started = false


var quest_title = {"q1":"Plastic Collection","q2":"Sample2","q3":"Sample3"}
var quest_info = {"q1":"Get 5 Plastic Bottles"}
var comp_text = {"q1": ""}

#Quest Types: gathering, question, kill, 
var quest_type = {"q1":"gather"}  
var req_materials = {"q1": ["Plastic",5]}

var active_quest = {"q1":false,"q2":false,"q3":false,"q4":false}
var completed_quest =  {"q1":false,"q2":false,"q3":false,"q4":false}
var decision = {"q1": 0 , "q2": 0, "q3": 0}


#Point System
var dialogue_points = 0

#Item

var multiplier = 0.5
var items = {"Plastic": 1,"Logs": 3,"Seeds": 1,"Trash": 0}



#Save Data
var data_path = "res://Data/PlayerChoices.json"

#Player Choice data
func save_data(quest, val):
	var file = FileAccess.open(data_path, FileAccess.READ_WRITE)
	var json_string = FileAccess.get_file_as_string(data_path)
	var json_dict = JSON.parse_string(json_string)
	json_dict["1"][quest] = val
	var updated_json = JSON.stringify(json_dict)
	file.open(data_path, FileAccess.WRITE)
	file.store_string(updated_json)
	file.close()

	

func change_scene():
	get_tree().change_scene_to_file(curr_scene)





func save(_save_path):
	save_database = {
	"game_started" : game_started,
	"curr_scene" : curr_scene,
	"active_quest": active_quest,
	"completed_quest" : completed_quest,
	"items" : items,
	"player_pos" : player.global_position
	}

	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	
	var jstr = JSON.stringify(save_database)
	file.store_line(jstr)
	print(jstr)
	file.close()
	
func load_save(_save_path):
	if FileAccess.file_exists(_save_path):
		var file = FileAccess.open(_save_path, FileAccess.READ)
		if not file:
			return
		if file == null:
			return
		if FileAccess.file_exists(_save_path) == true:
			var json = JSON.new()
			json.parse(file.get_as_text())
			var data = json.get_data()
			game_started = data["game_started"]
			curr_scene = data["curr_scene"]
			player_pos = str_to_var("Vector3" + data["player_pos"])
			change_scene()
			items = data["items"]
			active_quest = data["active_quest"]
			completed_quest = data["completed_quest"]
			
			
			file.close()
	else:
		print("no data saved")

