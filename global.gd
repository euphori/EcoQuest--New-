extends Node

var questStart = false
var game_started = false

var quest_title = ["Plastic Collection","Sample2","Sample3"]
var quest_info = ["Get 10 Plastic Bottles"]
var active_quests = {0:true,1:false,2:false,3:false}
var completed_quests = {0:false,1:false,2:false,3:false}

#Questions
var question1_complete = false
var question2_complete = false
var question3_complete = false
var question4_complete= false
var question5_complete = false

#Quest Completion
var questOne_complete = false
var questTwo_complete = false
var questThree_complete = false
var questFour_complete = false
var questFive_complete = false

#Point System
var dialogue_points = 0

#Item

var multiplier = 0.5
var items = {"Plastic": 1,"Logs": 3,"Seeds": 1,"Trash": 0}
