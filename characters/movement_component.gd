extends CharacterBody3D

@export_category("STATS")
@export var SPEED = 10
@export var JUMP_VELOCITY = 7
@export var ACCELERATION = 150
@export var MAX_SPEED = 10
@export var DASH_SPEED = 50
@export var HEALTH = 100
@export var ENERGY = 100
@export var MAX_HEALTH = 100

@export_category("Dash")
@export var dash_cooldown = 1
@export var dash_cost_stamina = false
@export var dash_cost = 50

@export_category("Others")
@export var default_char = false
@export var can_move = true
@export var attacking = false

@export_category("Other Player")
@export var path_to_other : NodePath


@onready var charge = $Charge
@onready var console = get_parent().get_node("Console")
@onready var sprite = $Sprite3D
@onready var left_muzzle = $LeftMarker
@onready var right_muzzle = $RightMarker
@onready var left = $LeftMarker2
@onready var right = $RightMarker2


@onready var attack = $attack
@onready var dash = $dash
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var busy = false
var active = false
var pushing = false
var npc_in_range = false
var can_dash = true
var dashing = false
var dead
var can_die = true


var is_on_platform = false
var platform = null



func _ready():
	if GlobalMusic.status != "neutral":
		GlobalMusic.change_music("neutral")
	if default_char:
		dead = false
		can_move = true
		active = true
		global.player = self
		HEALTH = 100


func jump():
	velocity.y = JUMP_VELOCITY


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		$AnimationPlayer.play("falling")
	if !dead:
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
			dash.play()
			if dash_cost_stamina:
				if get_parent().energy_bar.value >= dash_cost:
					if velocity.x != 0:
						velocity.x = direction.x * DASH_SPEED
					else:
						if $Sprite3D.flip_h:
							velocity.x = -1 *  float(DASH_SPEED/2)
						else:
							velocity.x = 1 * float(DASH_SPEED/2)
					can_dash = false
					dashing = true
					$DashTimer.start(0.1)
					$DashCooldown.start(dash_cooldown)
					$RechargeTimer.start(2)
					if sprite.flip_h == true:
						var tween = get_tree().create_tween()
						tween.tween_property(charge, "global_position", left.global_position, 0.05)
					else:
						var tween = get_tree().create_tween()
						tween.tween_property(charge, "global_position", right.global_position, 0.05)
					$AnimationPlayer2.stop()
					charge.visible = true
					var tween = get_tree().create_tween()
					await tween.tween_property(get_parent().energy_bar, "value",  get_parent().energy_bar.value - dash_cost , 0.5).finished
					await get_tree().create_timer(.3).timeout
					charge.visible = false
				else:
					
					charge.visible = true
					if sprite.flip_h:
						$AnimationPlayer2.play("shake_left")
					elif !sprite.flip_h:
						$AnimationPlayer2.play("shake_right")
					await get_tree().create_timer(.3).timeout
					charge.visible = false
			else:
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

	if can_move:
		move_and_slide()
		




