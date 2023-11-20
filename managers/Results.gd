extends Control

@onready var awareness = $Awareness

var result = ""

var comment = {"Low" : "Needs more improvements" , "Average": "Getting there, slight improvements", "High" : "Influence and educate others." , "Invalid": "Insuficient Data"}

# Called when the node enters the scene tree for the first time.
func _ready():
	global.connect("update_quest" , update_result)


func _input(event):
	if event.is_action_pressed("esc"):
		if self.visible:
			self.visible = true


func update_result():
	if global.quest["chapter5"]["q2"].completed:
		self.visible = true
	var sa = global.awareness_points["SolutionAwareness"]
	var gk = global.awareness_points["GeneralKnowledge"]
	var pa =  global.awareness_points["PollutionAwareness"]
	
	if gk <= 4 and pa <= 6 and sa <= 4:
		result = "Low"
	elif gk >= 5 and pa >= 7 and sa >= 5:
		if gk > 5 and gk < 8 and pa > 7 and pa < 10 and sa > 5 and pa < 8:
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
