extends CharacterBody3D

@export_category("STATS")
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 10
@export var ACCELERATION = 200
@export var MAX_SPEED = 5.0


@export var default_char = false
@export var can_move = true
@export var attacking = false
@export_category("Other Player")
@export var path_to_other : NodePath

@onready var other_player = get_node(path_to_other)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var busy = false
var active
var pushing = false



func _ready():
	if default_char:
		active = true


func jump():
	velocity.y = JUMP_VELOCITY


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	
	if Input.is_action_just_pressed("attack") and active and !attacking:
		if $AnimationPlayer.has_animation("attack"):
			$AnimationPlayer.play("attack")
			attacking = true
			can_move = false
		


	if Input.is_action_just_pressed("jump") and is_on_floor() and !busy and active:
		jumping = true
		velocity.y += JUMP_VELOCITY
		$AnimationPlayer.play("jump")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("falling")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.x and active and can_move:
		if is_on_floor():
			jumping = false
		velocity.x = direction.x * SPEED
		if !jumping and !busy:
			$AnimationPlayer.play("run")
		if velocity.x  < 0 and !busy :
			$HitDetection.scale.x = -$HitDetection.scale.x
			$Sprite3D.flip_h = true
		elif velocity.x  > 0 and !busy :
			$HitDetection.scale.x = -$HitDetection.scale.x
			$Sprite3D.flip_h = false
	elif direction.x == 0 and active and !attacking:
		if !jumping and !busy:
			$AnimationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if !active:
		var destination = self.global_position.direction_to(other_player.global_position)
		var distance = self.global_position - other_player.global_position
		if abs(distance.x) > 4:
			velocity.x += destination.x * ACCELERATION * delta 
			velocity = velocity.limit_length(MAX_SPEED)
			if abs(velocity.x) != 0:
				$AnimationPlayer.play("run")
			else:
				$AnimationPlayer.play("idle")
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			$AnimationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if velocity.x < 0:
			$Sprite3D.flip_h = true
			$HitDetection.scale.x = -$HitDetection.scale.x
		elif velocity.x > 0:
			$Sprite3D.flip_h = false
			$HitDetection.scale.x = -$HitDetection.scale.x
		


	if can_move:
		move_and_slide()
		




