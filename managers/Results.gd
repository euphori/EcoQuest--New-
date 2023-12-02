extends Control

@onready var awareness = $Awareness

var result = ""

var comment = {"Low" : "Needs more improvements" , "Average": "Getting there, slight improvements", "High" : "Influence and educate others." , "Invalid": "Insuficient Data"}

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_questions()
	global.connect("update_quest" , update_result)


func _input(event):
	if event.is_action_pressed("esc"):
		if self.visible:
			self.visible = false


func update_result():

	if global.quest["chapter5"]["q3"].active:
		self.visible = true
		var sa = global.awareness_points["SolutionAwareness"]
		var gk = global.awareness_points["GeneralKnowledge"]
		var pa =  global.awareness_points["PollutionAwareness"]
		print(sa," " , gk , " ", pa)
		if gk >= 4:
			result = "Average"
		elif sa+gk+pa >= 15:
			result = "Average"
		elif gk < 3 or pa <= 3 or sa <= 3:
			result = "Low"
		elif gk >= 5 and gk < 8 or pa < 10 or sa < 8:
			result = "Average"
		elif gk >= 8 and pa >= 10 and sa >= 8:
			result = "High"
		else:
			result = "Invalid"
		
		awareness.text = result
		$Comment.text = comment[result]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_data(path):
	var file = path
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)

func initialize_questions():
	var counter = 0
	var similar_amount = {"Question1": 0.0,"Question2": 0.0,"Question3": 0.0,"Question4": 0.0,"Question5": 0.0,"Question6": 0.0,"Question7": 0.0,}
	for question in $Level/Questions/QuestionStats.get_children():
		question.get_node("QuestNumber").text = str("Question #", counter + 1 )
		counter += 1
		var quest_label = question.get_node("Question")
		var answer_label = question.get_node("Answer")
		var file = "res://Data/QuestionList.json"
		var json_as_text = FileAccess.get_file_as_string(file)
		var data = JSON.parse_string(json_as_text)
		quest_label.text = data[question.name]["question"]
		answer_label.text = data[question.name][global.decision[question.name]]
		
		#Find similar choices
		var dataset = "res://Data/ChoicesDataset.json"
		var text = FileAccess.get_file_as_string(dataset)
		var choices_data = JSON.parse_string(text)
		
		
		for choices in choices_data:
			if choices[question.name] == global.decision[question.name]:
				similar_amount[question.name] += 1
				
		
		#Put in percent
		var percent = question.get_node("TextureProgressBar")
		var percent_label = question.get_node("Percent")
		percent.value = (similar_amount[question.name] / 32) * 100
		percent_label.text = str(percent.value , "%", " had similar answer")
		print(question.name,"  ",similar_amount[question.name], " percent: " , (similar_amount[question.name] / 32) * 100 )
		


func _on_okay_button_pressed():
	self.visible = false
