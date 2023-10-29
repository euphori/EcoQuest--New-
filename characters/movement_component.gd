extends CharacterBody3D

@export_category("STATS")
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 7
@export var ACCELERATION = 150
@export var MAX_SPEED = 5.0
@export var DASH_SPEED = 50
@export var HEALTH = 100
@export var ENERGY = 25
@export var MAX_HEALTH = 100

@export_category("Cooldowns")
@export var dash_cooldown = 1


@export var default_char = false
@export var can_move = true
@export var attacking = false
@export_category("Other Player")
@export var path_to_other : NodePath


@onready var other_player = get_node(path_to_other)
@onready var console = get_parent().get_node("Console")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var busy = false
var active = false
var pushing = false
var npc_in_range = false
var can_dash = true
var dashing = false

var is_on_platform = false
var platform = null



func _ready():
	if default_char:
		active = true
		global.player = self
		if global.game_started and global.player_pos != null:
			self.global_position = global.player_pos




func jump():
	velocity.y = JUMP_VELOCITY


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		$AnimationPlayer.play("falling")
	
	
	
	if console.is_console_visible:
		can_move = false
	else:
		can_move = true
	
	if npc_in_range == true:
		if Input.is_action_just_pressed("talk"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "start")
	
	
	if Input.is_action_just_pressed("attack") and active and !attacking:
		if $AnimationPlayer.has_animation("attack"):
			$AnimationPlayer.play("attack")
			attacking = true
			can_move = false
		
	if pushing:
		print("PUSHING")
		busy = true
		$AnimationPlayer.play("pushing")
	else:
		busy = false

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
	
	

	
	if direction.x and active and can_move and !dashing:
		
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
	elif direction.x == 0 and active and !attacking and is_on_floor():
		if !jumping and !busy:
			$AnimationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("dash") and can_dash:
		
		if velocity.x != 0:
			velocity.x = direction.x * DASH_SPEED
		else:
			if $Sprite3D.flip_h:
				velocity.x = -1 * DASH_SPEED/2
			else:
				velocity.x = 1 * DASH_SPEED/2
		can_dash = false
		dashing = true
		$DashTimer.start(0.1)
		$DashCooldown.start(dash_cooldown)
		#velocity.x = direction.x * DASH_SPEED


	if can_move:
		move_and_slide()
		




