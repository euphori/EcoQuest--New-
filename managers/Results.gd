extends Control

@onready var awareness = $Level/Awareness

var result = ""

var comment = {
	"Low" : "Needs more improvements" , 
	"Average": "Getting there, slight improvements", 
	"High" : "Influence and educate others." , 
	"Invalid": "Insuficient Data"}

# Called when the node enters the scene tree for the first time.
func _ready():

	global.connect("update_quest" , update_result)


func _input(event):
	if event.is_action_pressed("esc"):
		if self.visible:
			self.visible = false


func prediction():
	var sa = global.pre_ap["SolutionAwareness"]
	var gk = global.pre_ap["GeneralKnowledge"]
	var pa =  global.pre_ap["PollutionAwareness"]
	var total = sa + gk + pa 
	
	if gk >= 7 and pa >= 10 and sa >= 7 and total >= 24:
		result = "High"
	elif (gk >= 5 and gk < 7) or (pa >= 7 and pa < 10) or (sa >= 5 and sa < 7) and total >= 17:
		result = "Average"
	elif gk <= 4 or pa <= 6 or sa <=4 and total >= 14:
		result = "Low"
	else:
		result = "Invalid"
	$Level/Prediction.text = result

func update_result():

	if global.quest["chapter5"]["q3"].active or global.quest["chapter1"]["q1"].active:
		prediction()
		initialize_questions()
		self.visible = true
		var sa = global.awareness_points["SolutionAwareness"]
		var gk = global.awareness_points["GeneralKnowledge"]
		var pa =  global.awareness_points["PollutionAwareness"]
		var total = sa + gk + pa
		print(sa," " , gk , " ", pa)
		if gk >= 7 and pa >= 10 and sa >= 7 and total >= 24:
			result = "High"
		elif (gk >= 5 and gk < 7) or (pa >= 7 and pa < 10) or (sa > 5 and sa < 7) and total >= 17:
			result = "Average"
		elif gk <= 4 or pa <= 6 or sa <=4 and total >= 14:
			result = "Low"
		else:
			result = "Invalid"
		
		print(sa," ",gk," ",pa)
		awareness.text = result
		$Level/Comment.text = str("Recommendation: \n" ,comment[result])
		#Star UI
		match result:
			"Average":
				$Level/Stars.value = 66
			"High":
				$Level/Stars.value = 99
			"Low":
				$Level/Stars.value = 33
		
		initialize_questions()

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
		answer_label.text = data[question.name][global.decisions[question.name]]
		
		#Find similar choices
		var dataset = "res://Data/ChoicesDataset.json"
		var text = FileAccess.get_file_as_string(dataset)
		var choices_data = JSON.parse_string(text)
		
		for choices in choices_data:
			if choices[question.name] == global.decisions[question.name]:
				similar_amount[question.name] += 1
				
		
		#Put in percent
		var percent = question.get_node("TextureProgressBar")
		var percent_label = question.get_node("Percent")
		percent.value = (similar_amount[question.name] / 32) * 100
		percent_label.text = str(percent.value , "%", " had similar answer")
		print(question.name,"  ",similar_amount[question.name], " percent: " , (similar_amount[question.name] / 32) * 100 )
		


func _on_okay_button_pressed():
	self.visible = false
