extends RigidBody3D



var speed = .3  # Adjust this to control the movement speed
var can_move


func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	var direction = Vector3( Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),0.0,Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward") ).normalized()
# Check for input or any other condition that triggers movement
# Apply a force to the RigidBody3D in its local space
	var force = direction * speed
	if can_move:
		apply_central_impulse(force)

