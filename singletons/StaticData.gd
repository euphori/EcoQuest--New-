extends Node

var item_data = {}
var data_file_path = "res://Data/PlayerChoices.json"


func _ready():
	item_data = load_json_file(data_file_path)
	

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	
	else:
		print("File doesn't exist!")
	
