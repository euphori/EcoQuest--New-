extends Node


var _player_id 
var player_id = 0

var env_condition = 10

var awareness_points = {
	"SolutionAwareness" : 0,
	"GeneralKnowledge": 0,
	"PollutionAwareness": 0
}

var pre_ap = {
	"SolutionAwareness" : 0,
	"GeneralKnowledge": 0,
	"PollutionAwareness": 0
}

var scooter_repaired = false
@onready var player
var last_player_pos = {
	"Forest" : "" ,
	"Hub" : "" ,
	"Desert" : ""  , 
	"City" : "" ,
	"Snow" : ""  ,
	"Lab" : ""  ,
	"Arcade" : ""
	}
var player_hp = 100
var next_scene 

var enemy_cleared = { 
	"Forest": false,
	"Desert": false
	
}	


signal update_quest
signal transistion
signal pickup_item(item,ammount)
signal item_added
signal game_saved
signal update_env

var save_path = {"save1" : "user://save1.txt", "save2" : "user://save2.save", "save3" : "user://save3.save" }
var player_save_path = "user://playerid.txt"
var curr_scene
var curr_scene_name
var curr_level
var save_database 

var questStart = false
var game_started = false
var fixed_pipe = false
var curr_killcount = 0
var in_dialogue = false
var quest = {

	"chapter1":{
		"q1": {
			"title": "Adventure I",
			"desc" : "Explore the area",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : true,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q2": {
			"title": "Adventure I",
			"desc" : "Collect 5 woods to build a boat",
			"type" : "gather",
			"req_items" : ["Wood", 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : true
		},
		"q3": {
			"title": "Adventure I",
			"desc" : "Go meet Lucas in the docks",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
			
		},
		"q4": {
			"title": "Adventure I",
			"desc" : "Protect Lucas from the Robots",
			"type" : "defend",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q4.5": {
			"title": "Adventure I",
			"desc" : "Use the boat and go to Briarwood Harbour",
			"type" : "travel",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q5": {
			"title": "Adventure I",
			"desc" : "Talk to Lucas",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		
		},
		"q6": {
			"title": "Adventure I",
			"desc" : "Find and talk to the OldTom",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : false
		
		},
		"q7": {
			"title": "Adventure I",
			"desc" : "Collect trash that are scattered in the area",
			"type" : "gather",
			"req_items" : ["Trash" , 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : true
		
		},
	},
	"chapter2":{
		"q1": {
			"title": "Adventure II",
			"desc" : "Go to Rusty Bay and investigate",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Harper",
			"talk_after" : false
		},
		"q2": {
			"title": "Adventure II",
			"desc" : "Defeat Robots to restore water",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Harper",
			"talk_after" : true,
			"kill_req": 3
		},
		"q3": {
			"title": "Adventure II",
			"desc" : "Find the missing tool and fix pipe",
			"type" : "gather",
			"req_items" : ["Wrench" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Harper",
			"talk_after" : false,
		},
		"q5": {
			"title": "Adventure II",
			"desc" : "Go to Briarwood Harbor and talk to OldTom",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : false,
		},
	},
	"chapter3":{
		"q1": {
			"title": "Adventure III",
			"desc" : "Go to Whispering Woods and talk to Lucas",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q2": {
			"title": "Adventure III",
			"desc" : "Gather data from the forest",
			"type" : "gather",
			"req_items" : ["Data" , 3],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : true
		},
		"q3": {
			"title": "Adventure III",
			"desc" : "Defeat Robots to protect data",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false,
		},
		"q4": {
			"title": "Adventure III",
			"desc" : "Go to Briarwood Harbor and talk to OldTom",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : false,
		},
		"q5": {
			"title": "Adventure III",
			"desc" : "Go to workshop and fix Electric Scooter",
			"type" : "Fix",
			"req_items" : ["Scraps" , 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Harper",
			"talk_after" : true,
		},
	},
	"chapter4":{
		"q1": {
			"title": "Adventure IV",
			"desc" : "Go to Citadel Heights and talk to Harper",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Harper",
			"talk_after" : false
		},
		"q2": {
			"title": "Adventure IV",
			"desc" : "Collect parts to build Solar Panel",
			"type" : "gather",
			"req_items" : ["Glass", 1, "Metal Frame", 1 , "Metal Sheet", 1 , "Junction Box", 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Harper",
			"talk_after" : false
		},
		"q3": {
			"title": "Adventure IV",
			"desc" : "Go to Polar Pine and talk to the Professor",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : false
		},
		"q4": {
			"title": "Adventure IV",
			"desc" : "Protect Professor and defeat Robots",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : true,
			"kill_req": 4
		},
		"q5": {
			"title": "Adventure IV",
			"desc" : "Go inside the lab to shut down factory",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : false
		},
		"q6": {
			"title": "Adventure IV",
			"desc" : "Go outside and talk to Professor",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : false
		},
	},
	"chapter5":{
		"q1": {
			"title": "Adventure V",
			"desc" : "Go to Briarwood Harbor and talk to OldTom",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : false
		},
		"q2": {
			"title": "Adventure V",
			"desc" : "Defeat Robots to protect the Trees",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : true,
			"kill_req": 2
		},
		"q3": {
			"title": "The End",
			"desc" : "Check your results",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "OldTom",
			"talk_after" : false
		},
	},
	}
	
#var quest_info = {
	#"tutorial":"Gather 5 woods",
	# "q1":"Get 5 Plastic Bottles",
	#"q2":"Find Tool and Fix Pipe", 
	#"q4":"Get 5 Solar Panel Parts"}
	


func get_active_quest():
	for i in quest:
		for x in quest[i]: #get all quest in global
			var _quest = quest[i][x]
			if _quest.active: #find the active quest
				return _quest


var item_texture = {
	"Wood" : "res://assets/item_textures/wood.png",
	"Trash" : "res://assets/item_textures/Can.png",
	"Wrench" :"res://assets/item_textures/wrench.png",
	"Scraps": "res://assets/item_textures/Scraps.png",
	"Glass": "res://assets/item_textures/glass.png",
	"Metal Frame": "res://assets/item_textures/mframe.png",
	"Metal Sheet": "res://assets/item_textures/msheet.png",
	"Junction Box": "res://assets/item_textures/jbox.png",
	
}

var comp_text = {"q1": ""}

#Quest Types: gathering, question, kill, 
#var quest_type = {"tutorial":"gather", "q1":"gather", "q2":"fix", "q4":"gather"}  
##var req_materials = {"tutorial": ["Wood",5],"q1": ["Plastic",5],"q2": ["Wrench",1], "q4": ["Solar Panel Parts",5]}

#var active_quest = {"tutorial":false, "q1":false,"q2":false,"q3":false,"q4":false, "q5":false}
#var completed_quest =  {"tutorial":false, "q1":false,"q2":false,"q3":false,"q4":false, "q5":false}
var decision = {"Question1": "a1" ,"Question2": "a1" ,"Question3": "a1" ,"Question4": "a1" ,"Question5": "a1" ,"Question6": "a1" ,"Question7": "a1" ,}


# SCENES THAT PLAYERS CAN TRAVEL TO
var unlocked_map = {"Forest" : true , "Hub": true , "Snow" : false , "Desert" : false , "City" : false}


#Point System
var dialogue_points = 0

#Item

var multiplier = 0.5
var items = {"Wood": 1, "Plastic": 1,"Logs": 3,"Seeds": 0,"Trash": 0, "Wrench": 0, "Glass": 0, "Metal Frame": 0,"Metal Sheet": 0, "Junction Box": 0,"Data": 0, "Scraps": 0}





#Save Data
var choices_path = "res://Data/PlayerChoices.json"
var survey_path = "res://Data/Presurvey.json"

#Player Choice data
func save_data(survey):
	var data_path
	var val
	if survey == "pre":
		data_path = survey_path
		val = pre_ap
	else:
		data_path = choices_path
		val = awareness_points
	var file = FileAccess.open(data_path, FileAccess.READ_WRITE)
	var json_string = FileAccess.get_file_as_string(data_path)
	var json_dict = JSON.parse_string(json_string)
	json_dict[player_id] = val
	var updated_json = JSON.stringify(json_dict)
	file.open(data_path, FileAccess.WRITE)
	file.store_string(updated_json)
	file.close()

	

func change_scene():
	var loading_screen = load("res://UI/loading_screen.tscn")
	global.next_scene = curr_scene
	get_tree().change_scene_to_packed(loading_screen)







func save_player_id():
	_player_id = player_id
	var file = FileAccess.open(player_save_path, FileAccess.WRITE)
	var jstr = JSON.stringify(_player_id)
	file.store_line(jstr)
	file.close()
	
func load_player_id():
	if FileAccess.file_exists(player_save_path):
			var file = FileAccess.open(player_save_path, FileAccess.READ)
			if not file:
				return
			if file == null:
				return
			if FileAccess.file_exists(player_save_path) == true:
				var json = JSON.new()
				json.parse(file.get_as_text())
				var data = json.get_data()
				player_id = data
				file.close()
	else:
		print("no data saved")
func save(_save_path):
	emit_signal("game_saved")
	last_player_pos[curr_scene_name] = str(player.global_position)
	save_database = {
	"player_hp" : player.HEALTH,
	"game_started" : game_started,
	"curr_scene" : curr_scene,
	"quest" : quest,
	"items" : items,
	"last_player_pos" : last_player_pos,
	"unlocked_map" : unlocked_map,
	"awareness_points" : awareness_points
	}

	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	
	var jstr = JSON.stringify(save_database)
	file.store_line(jstr)
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
			player_hp = data["player_hp"]
			game_started = data["game_started"]
			curr_scene = data["curr_scene"]
			last_player_pos = data["last_player_pos"]
			items = data["items"]
			quest = data["quest"]
			unlocked_map = data["unlocked_map"]
			awareness_points = data["awareness_points"]
			change_scene()
			file.close()
	else:
		print("no data saved")

