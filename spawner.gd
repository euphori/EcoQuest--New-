extends Node3D

@export_category("Spawn Requirements")
@export var chapter_name : String
@export var quest_to_complete : String
@export var active_quest : String

@export var quest_fulfilled : String
@export_category("Object to spawn")
@export var path_to_scene : String
@export var spawn_id : String
@export var ammount = 1
@onready var scene = load(path_to_scene)

var spawned = {"r1": false , "r2": false, "r3": false}

func _ready():
	global.connect("update_quest" , spawn)

func spawn():
	if global.quest[chapter_name][quest_to_complete].completed and spawned[spawn_id] == false and global.quest[chapter_name][active_quest].active:
		for i in ammount:
			var object = scene.instantiate()
			object.global_position = $Marker3D.global_position
			get_parent().add_child(object)
			object.get_node("Sprite3D").flip_h = true
			object.death_quest_trigger[0] = chapter_name
			object.death_quest_trigger[1] = quest_fulfilled
		spawned[spawn_id]= true 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
