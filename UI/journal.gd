extends Control

@onready var curr_quest
@onready var curr_quest_title = $Quest/CurrentQuestTitle
@onready var quest_info = $Quest/QuestInfo
# Called when the node enters the scene tree for the first time.
func _ready():
	get_curr_quest()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func get_curr_quest():
	for i in global.active_quests:
		if global.active_quests[i] == true:
			curr_quest = i
	print(curr_quest)
	curr_quest_title.text = global.quest_title[curr_quest]
	quest_info.text = global.quest_info[curr_quest]
