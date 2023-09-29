extends RigidBody3D



var move_speed = 10.0  # Adjust this value to control the platform's movement speed.
var direction = Vector3(1, 0, 0)  # Adjust the direction of movement.

func _physics_process(delta):
	var force = direction * move_speed
	apply_impulse(Vector3.ZERO, force)
