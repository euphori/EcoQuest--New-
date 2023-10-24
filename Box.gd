extends CharacterBody3D

@export var path_to_player: NodePath

@onready var player = get_node(path_to_player)

var speed = 1  # Adjust this to control the movement speed
var can_move = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	var direction = Vector3( Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),0.0,0.0).normalized()

	var velocity = direction * speed
	if can_move:
		player.pushing = true
		move_and_collide(velocity)
	else:
		player.pushing = false

