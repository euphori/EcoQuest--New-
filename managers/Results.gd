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


func _on_okay_button_pressed():
	self.visible = false
