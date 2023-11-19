extends Node3D

@export_category("Spawn Requirements")
@export var chapter_name : String
@export var quest_to_complete : String
@export var active_quest : String

@export var quest_fulfilled : String
@export_category("Object to spawn")
@export var path_to_scene : String
@export var spawn_id : String

@onready var scene = load(path_to_scene)

var spawned = {"r1": false , "r2": false}

func _ready():
	global.connect("update_quest" , spawn)

func spawn():
	if global.quest[chapter_name][quest_to_complete].completed and !spawned[spawn_id] and global.quest[chapter_name][active_quest].active:
	
		var object = scene.instantiate()
		object.global_position = $Marker3D.global_position
		get_parent().add_child(object)
		print("ENEMY SPAWNED: ", object)
		spawned[spawn_id]= true 
		object.death_quest_trigger[0] = chapter_name
		object.death_quest_trigger[1] = quest_fulfilled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
