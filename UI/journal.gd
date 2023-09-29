extends Control

@onready var curr_quest
@onready var curr_quest_title = $Quest/CurrentQuestTitle
@onready var quest_info = $Quest/QuestInfo
@onready var slots = $Inventory/GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	get_curr_quest()
	initialize_inv()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _input(event):
	if event.is_action_pressed("journal"):
		if self.visible:
			initialize_inv()
			update_quantity()
			self.visible = false
		else:
			initialize_inv()
			update_quantity()
			self.visible = true


func get_curr_quest():
	for i in global.active_quests:
		if global.active_quests[i] == true:
			curr_quest = i
	print(curr_quest)
	curr_quest_title.text = global.quest_title[curr_quest]
	quest_info.text = global.quest_info[curr_quest]


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
