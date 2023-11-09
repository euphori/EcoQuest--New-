extends Node3D

@export_category("Spawn Requirements")
@export var chapter_name : String
@export var completed_quest : String

@export_category("Object to spawn")
@export var path_to_scene : String

@onready var scene = load(path_to_scene)

var spawned = false

func _ready():
	global.connect("update_quest" , spawn)

func spawn():
	if global.quest[chapter_name][completed_quest].completed and !spawned:
		spawned = true
		var object = scene.instantiate()
		object.global_position = $Marker3D.global_position
		get_parent().add_child(object)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
