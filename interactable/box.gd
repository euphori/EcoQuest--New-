extends CharacterBody3D



@export var path_to_manager : NodePath
@onready var manager = get_node(path_to_manager)

const SPEED = 4.0
var can_move = false
var colliding = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()

	if manager.kid.pushing == false:
		manager.kid.SPEED = manager.kid.MAX_SPEED
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.z = 0
	if $LeftRay.is_colliding() or $RightRay.is_colliding():
		$InteractUI.visible = true
		colliding = true
		
	else:
		$InteractUI.visible = false
		colliding = false
	if can_move:
		if $LeftRay.is_colliding() or $RightRay.is_colliding():
			velocity.x = direction.x * SPEED
			manager.kid.SPEED = SPEED
			
		else:

			manager.kid.pushing = false
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity = Vector3.ZERO
	
	move_and_slide()




func _on_interact_ui_move():
	manager.kid.pushing = true


func _on_interact_ui_stop():
	manager.kid.pushing = false
