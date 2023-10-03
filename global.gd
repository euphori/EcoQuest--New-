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


#Point System
var dialogue_points = 0

#Item

var multiplier = 0.5
var items = {"Plastic": 1,"Logs": 3,"Seeds": 1,"Trash": 0}
