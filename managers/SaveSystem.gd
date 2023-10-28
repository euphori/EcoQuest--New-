extends Node3D

var save_path = {"save1" : "user://save1.txt", "save2" : "user://save2.save", "save3" : "user://save3.save" }


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func save(_save_path, variable):
	var file = FileAccess.open(_save_path, FileAccess.WRITE)
	file.store_var(variable)
