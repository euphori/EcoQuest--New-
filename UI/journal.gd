extends Control

@onready var curr_quest
@onready var curr_quest_title = $Quest/CurrentQuestTitle
@onready var quest_info = $Quest/QuestInfo
@onready var quest_req = $Quest/QuestRequirements
@onready var slots = $Inventory/GridContainer
@onready var fin_quest = $Quest/FinishedQuests
@onready var map = $Map
@onready var open = $Open
@onready var close = $Close
@onready var select = $Select

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
			close.play()
			get_curr_quest()
			initialize_inv()
			update_quantity()
			update_quest()
			update_save_slot()
			map.initialize_map()
			self.visible = false
		else:
			open.play()
			get_curr_quest()
			initialize_inv()
			update_quantity()
			update_quest()
			map.initialize_map()
			self.visible = true
			$Quest.visible = true
			$Inventory.visible = false
			$PauseMenu.visible = false
			$Load.visible = false
			$Map.visible = false
	elif event.is_action_pressed("esc"):
		get_curr_quest()
		initialize_inv()
		update_quantity()
		update_quest()
		update_save_slot()
		self.visible = !self.visible 
		$PauseMenu.visible = true
		$Quest.visible = false
		$Inventory.visible = false
		$Load.visible = false
		$Map.visible = false


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
						slot.text = i
					if quant.text == "":
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
		

func update_save_slot():
	if global.save_path.save1 != null:
		$Load/Save1.text = "Load"
		print("QWEWQEWQEQW")


func show_map():
	open.play()
	visible = true
	$Quest.visible = false
	$Inventory.visible = false
	$PauseMenu.visible = false
	$Load.visible = false
	$Map.visible = true


func _on_inv_button_pressed():
	open.play()
	$Quest.visible = false
	$Inventory.visible = true
	$PauseMenu.visible = false
	$Load.visible = false
	$Map.visible = false

func _on_quest_button_pressed():
	open.play()
	$Quest.visible = true
	$Inventory.visible = false
	$PauseMenu.visible = false
	$Load.visible = false
	$Map.visible = false

func _on_exit_button_pressed():
	open.play()
	$Quest.visible = false
	$Inventory.visible = false
	$PauseMenu.visible = true
	$Load.visible = false
	$Map.visible = false

func _on_save_button_pressed():
	select.play()
	global.save(global.save_path["save1"])


func _on_load_button_pressed():
	select.play()
	global.load_save(global.save_path["save1"])
	#$Quest.visible = false
	#$Inventory.visible = false
	#$PauseMenu.visible = false
	#$Load.visible = true
	



func _on_slot_1_pressed():
	select.play()
	global.load_save(global.save_path["save1"])


func _on_slot_2_pressed():
	select.play()
	global.load_save(global.save_path["save2"])


func _on_slot_3_pressed():
	select.play()
	global.load_save(global.save_path["save3"])


func _on_quit_button_pressed():
	select.play()
	get_tree().quit()

