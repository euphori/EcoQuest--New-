extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _process(delta):
	
	if hide:
		if global.completed_quest["q4"]:
			self.visible = true 
		else:
			self.visible = false
	
