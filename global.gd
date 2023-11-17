extends Node



var env_condition = 10



@onready var player
var last_player_pos = {
	"Forest" : "" ,
	"Hub" : "" ,
	"Desert" : ""  , 
	"City" : "" ,
	"Snow" : ""  ,
	"Lab" : ""  ,
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

var save_path = {"save1" : "user://save1.txt", "save2" : "user://save2.save", "save3" : "user://save3.save" }
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
			"title": "Find a way out",
			"desc" : "Explore the area",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q2": {
			"title": "Build a boat",
			"desc" : "Find 5 woods to help fix the boat",
			"type" : "gather",
			"req_items" : ["Wood", 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : true
		},
		"q3": {
			"title": "New Adventures",
			"desc" : "Go meet NPC in the docks",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
			
		},
		"q4": {
			"title": "Defend the NPC",
			"desc" : "Don't let the npc die",
			"type" : "defend",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q4.5": {
			"title": "Briarwood Harbour",
			"desc" : "use the boat to travel",
			"type" : "travel",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Lucas",
			"talk_after" : false
		},
		"q5": {
			"title": "New Adventures II",
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
			"title": "New Adventures II",
			"desc" : "Find and talk to the Farmer",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : false
		
		},
		"q7": {
			"title": "Pick Up",
			"desc" : "Collect trash",
			"type" : "gather",
			"req_items" : ["Trash" , 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : false
		
		},
	},
	"chapter2":{
		"q1": {
			"title": "Rusty Bay",
			"desc" : "Go to Rusty Bay and investigate.",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Plumber John",
			"talk_after" : false
		},
		"q2": {
			"title": "Restore Water",
			"desc" : "Defeat Robots",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Plumber John",
			"talk_after" : true,
			"kill_req": 3
		},
		"q3": {
			"title": "Find Tool",
			"desc" : "Find the wrench",
			"type" : "gather",
			"req_items" : ["Wrench" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Plumber John",
			"talk_after" : false,
		},
		"q4": {
			"title": "Fix Pipe",
			"desc" : "Go to pipe",
			"type" : "fix",
			"req_items" : ["Wrench" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Plumber John",
			"talk_after" : false,
		},
		"q5": {
			"title": "Go to Briarwood Harbor",
			"desc" : "Talk to Farmer",
			"type" : "explore",
			"req_items" : ["Seeds" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : false,
		},
		"q6": {
			"title": "Plant",
			"desc" : "Plant the first seed",
			"type" : "plant",
			"req_items" : ["Seeds" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : true,
		},
	},
	"chapter3":{
		"q1": {
			"title": "Go to Whispering Woods",
			"desc" : "Talk to Elder",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Elder",
			"talk_after" : false
		},
		"q2": {
			"title": "Research",
			"desc" : "Gather data from the forest",
			"type" : "gather",
			"req_items" : ["Data" , 4],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Elder",
			"talk_after" : true
		},
		"q3": {
			"title": "Protect Data",
			"desc" : "Defeat Robots",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Elder",
			"talk_after" : true,
			"kill_req": 3
		},
		"q4": {
			"title": "Go to Briarwood Harbor",
			"desc" : "Talk to Farmer",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : false,
		},
		"q5": {
			"title": "Plant",
			"desc" : "Plant the second seed",
			"type" : "plant",
			"req_items" : ["Seeds" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : true,
		},
		"q6": {
			"title": "Fix Electric Scooter",
			"desc" : "Go to shop",
			"type" : "Fix",
			"req_items" : ["Scraps" , 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Mechanic",
			"talk_after" : true,
		},
	},
	"chapter4":{
		"q1": {
			"title": "Go to Citadel Heights",
			"desc" : "Talk to Mechanic",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Mechanic",
			"talk_after" : false
		},
		"q2": {
			"title": "Build Solar Panel",
			"desc" : "Collect solar panel parts",
			"type" : "gather",
			"req_items" : ["Solar Panel Parts" , 5],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Mechanic",
			"talk_after" : false
		},
		"q3": {
			"title": "Go to Polar Pine",
			"desc" : "Talk to Professor",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : false
		},
		"q4": {
			"title": "Protect Professor",
			"desc" : "Defeat Robots",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : true,
			"kill_req": 3
		},
		"q5": {
			"title": "Shut Down Factory",
			"desc" : "Go inside the laboratory",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : false
		},
		"q6": {
			"title": "Go outside",
			"desc" : "Talk to Professor",
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
			"title": "Go to Briarwood Harbor",
			"desc" : "Talk to Farmer",
			"type" : "explore",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : false
		},
		"q2": {
			"title": "Plant",
			"desc" : "Plant the last seed",
			"type" : "plant",
			"req_items" : ["Seeds" , 1],
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Farmer",
			"talk_after" : false,
		},
		"q3": {
			"title": "Protect the Trees",
			"desc" : "Defeat Robots",
			"type" : "kill",
			"req_items" : null,
			"weight" : null,
			"active" : false,
			"completed" : false,
			"npc_name" : "Professor",
			"talk_after" : true,
			"kill_req": 4
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
	"Scraps": "res://assets/item_textures/Scraps.png"
	
}

var comp_text = {"q1": ""}

#Quest Types: gathering, question, kill, 
#var quest_type = {"tutorial":"gather", "q1":"gather", "q2":"fix", "q4":"gather"}  
##var req_materials = {"tutorial": ["Wood",5],"q1": ["Plastic",5],"q2": ["Wrench",1], "q4": ["Solar Panel Parts",5]}

#var active_quest = {"tutorial":false, "q1":false,"q2":false,"q3":false,"q4":false, "q5":false}
#var completed_quest =  {"tutorial":false, "q1":false,"q2":false,"q3":false,"q4":false, "q5":false}
var decision = {"q1": 0 , "q2": 0, "q3": 0}


# SCENES THAT PLAYERS CAN TRAVEL TO
var unlocked_map = {"Forest" : true , "Hub": true , "Snow" : false , "Desert" : false , "City" : false}


#Point System
var dialogue_points = 0

#Item

var multiplier = 0.5
var items = {"Wood": 1, "Plastic": 1,"Logs": 3,"Seeds": 0,"Trash": 0, "Wrench": 0, "Solar Panel Parts": 0, "Data": 0, "Scraps": 0}





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
	
	last_player_pos[curr_scene_name] = str(player.global_position)
	save_database = {
	"player_hp" : player.HEALTH,
	"game_started" : game_started,
	"curr_scene" : curr_scene,
	"quest" : quest,
	"items" : items,
	"last_player_pos" : last_player_pos
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
			change_scene()
			file.close()
	else:
		print("no data saved")

