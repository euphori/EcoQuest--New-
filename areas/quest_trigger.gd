extends Area3D

@export var chapter_name : String 
## quest that needs to be active first
@export var active_quest_id : String

## quest that will activate once the player met the requirements
@export var next_quest_id : String

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player"):
		if global.quest[chapter_name][active_quest_id].active:
			global.quest[chapter_name][active_quest_id].completed = true
			global.quest[chapter_name][active_quest_id].active = false
			
			if next_quest_id != null:
				global.quest[chapter_name][next_quest_id].active = true
