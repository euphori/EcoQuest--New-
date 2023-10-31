extends RigidBody3D

@export var path_to_player: NodePath

@onready var player = get_node(path_to_player)

var speed = 1  # Adjust this to control the movement speed
var can_move = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	apply_central_force()

