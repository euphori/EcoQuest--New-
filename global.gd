extends Node

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
var save_path = "res://Data/PlayerChoices.json"

func save_data(quest, val):
	var file = FileAccess.open(save_path, FileAccess.READ_WRITE)
	var json_string = FileAccess.get_file_as_string(save_path)
	var json_dict = JSON.parse_string(json_string)
	json_dict["1"][quest] = val
	var updated_json = JSON.stringify(json_dict)
	file.open(save_path, FileAccess.WRITE)
	file.store_string(updated_json)
	file.close()
	print("QUEST: ",json_dict["1"][quest])
	
