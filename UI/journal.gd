extends Control

@onready var curr_quest
@onready var curr_quest_title = $Quest/CurrentQuestTitle
@onready var quest_info = $Quest/QuestInfo
@onready var quest_req = $Quest/QuestRequirements
@onready var slots = $Inventory/GridContainer
@onready var fin_quest = $Quest/FinishedQuests

var done = []
# Called when the node enters the scene tree for the first time.
func _ready():
	if curr_quest != null:
		get_curr_quest()
	else:
		clear_curr_quest()
	initialize_inv()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _input(event):
	if event.is_action_pressed("journal"):
		if self.visible:
			get_curr_quest()
			initialize_inv()
			update_quantity()
			update_quest()
			self.visible = false
		else:
			get_curr_quest()
			initialize_inv()
			update_quantity()
			update_quest()
			self.visible = true



func update_quest():
	for i in global.completed_quest:
		if global.completed_quest[i] == true and !done.has(global.completed_quest[i]):
			global.active_quest[i] = false
			done.append(global.completed_quest[i])
			fin_quest.text += str(global.quest_title[i],"\n")
			clear_curr_quest()
	
	if global.quest_type.has(curr_quest):
		if curr_quest != null and global.quest_type[curr_quest] == "gather" and global.completed_quest[curr_quest] == false :
			var req_item
			for x in global.items:
				if x == global.req_materials[curr_quest][0]:
					req_item = x
			if global.req_materials[curr_quest][1] <= global.items[req_item]:
				quest_info.text += "\nTalk to NPC"
	
func clear_curr_quest():
	curr_quest_title.text = "Nothing to do"
	quest_info.text = ""
	quest_req.text = ""
	curr_quest = null

func get_curr_quest():
	for i in global.active_quest:
		if global.active_quest[i] == true:
			curr_quest = i
			curr_quest_title.text = global.quest_title[curr_quest]
			if global.quest_info.has(curr_quest):
				quest_info.text = global.quest_info[curr_quest]
			else:
				quest_info.text = str(curr_quest, " info doesn't exist")
			var req_item
			if global.quest_type.has(curr_quest) and global.quest_type[curr_quest] == "gather":
				for x in global.items:
					if x == global.req_materials[curr_quest][0]:
						req_item = x
				quest_req.text = str(global.items[req_item],"/",global.req_materials[curr_quest][1], "  ",global.req_materials[curr_quest][0])
				quest_req.visible = true
			break
	print(curr_quest)
	


func initialize_inv():
	for i in global.items:
		if global.items[i] != 0:
			for x in (slots.get_child_count()/2):
				var slot
				var quant
				slot = slots.get_node(str("ItemName",x+1))
				quant = slots.get_node(str("Quantity",x+1))
				if slot.text == i:
					break
				else:
					if slot.text == "":
						
						print("ADDED ITEM NAME")
						slot.text = i
					if quant.text == "":
						print("ADDED QUANT")
						quant.text = str(global.items[i],"x")
						break

func update_quantity():
	var x = 0
	for i in global.items:
		if global.items[i] != 0:
			var quant
			quant = slots.get_node(str("Quantity",x+1))
			quant.text = str(global.items[i],"x")
			x += 1
		





func _on_inv_button_pressed():
	$Quest.visible = false
	$Inventory.visible = true

func _on_quest_button_pressed():
	$Quest.visible = true
	$Inventory.visible = false
