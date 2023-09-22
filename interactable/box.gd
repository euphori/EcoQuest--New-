extends CharacterBody3D



@export var path_to_manager : NodePath
@onready var manager = get_node(path_to_manager)

const SPEED = 5.0
var can_move = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.z = 0
	if manager.kid.active:
		if $LeftRay.is_colliding() or $RightRay.is_colliding() and can_move:
			velocity.x = direction.x * SPEED
			manager.kid.pushing = true
			move_and_slide()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		manager.kid.pushing = false
		velocity = Vector3.ZERO
		


