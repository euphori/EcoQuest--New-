extends CharacterBody3D

@export_category("STATS")
@export var SPEED = 10
@export var JUMP_VELOCITY = 7
@export var ACCELERATION = 150
@export var MAX_SPEED = 10
@export var DASH_SPEED = 100
@export var HEALTH = 100
@export var ENERGY = 100
@export var MAX_HEALTH = 100
@export var DAMAGE = 10

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
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")


@onready var attack = $attack

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var busy = false
var active = true
var pushing = false
var npc_in_range = false
var can_dash = true
var dashing = false
var dead
var can_die = true
var charging_attack = false
var jump_count = 0

var is_on_platform = false
var platform = null




func _ready():
	if GlobalMusic.status != "neutral":
		GlobalMusic.change_music("neutral")

	dead = false
	can_move = true
	active = true
	global.player = self
	HEALTH = 100


func jump():
	velocity.y += JUMP_VELOCITY


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		if !dashing and !jumping and !charging_attack:
			anim_state.travel("Fall")
	else:
		jump_count = 0
		jumping = false
	if !dead:
		if npc_in_range == true:
			if Input.is_action_just_pressed("talk"):
				DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "start")
		

		else:
			busy = false

		if Input.is_action_just_pressed("jump")  and !busy and active and !global.in_dialogue and !dashing and jump_count <= 1:
			jumping = true
			if global.curr_scene_name == "Arcade":
				jump_count += 1
			else:
				jump_count += 2
			velocity.y += JUMP_VELOCITY
			if !charging_attack:
				anim_state.travel("Jump")
			jumping = false
			
		
		

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		
		
		if input_dir != Vector2.ZERO and can_move and !global.in_dialogue:
			
			if !dashing:
				velocity.x = direction.x * SPEED
			anim_tree.set("parameters/Run/blend_position",input_dir.x)
			anim_tree.set("parameters/Idle/blend_position",input_dir.x)
			anim_tree.set("parameters/Charge/blend_position",input_dir.x)
			anim_tree.set("parameters/Shoot/blend_position",input_dir.x)
			anim_tree.set("parameters/Jump/blend_position",input_dir.x)
			anim_tree.set("parameters/Dash/blend_position",input_dir.x)
			anim_tree.set("parameters/Fall/blend_position",input_dir.x)
			anim_tree.set("parameters/Push Idle/blend_position",input_dir.x)
			
			if !pushing:
				anim_tree.set("parameters/Push/blend_position",input_dir.x)
			
			if is_on_floor() and !charging_attack and !jumping and !dashing and !pushing:
				anim_state.travel("Run")
			elif pushing:
				anim_state.travel("Push")
		elif input_dir == Vector2.ZERO:
			if is_on_floor() and !charging_attack and !jumping and !dashing and !pushing:
				anim_state.travel("Idle")
			elif pushing:
				anim_state.travel("Push Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
		if Input.is_action_just_pressed("dash") and can_dash and !global.in_dialogue:
			dashing = true
			$Bolt.visible = true
			if anim_tree.get("parameters/Dash/blend_position") < 0:
				$BoltAnim.play("default_left")
			else:
				$BoltAnim.play("default_right")
			if !charging_attack:
				anim_state.travel("Dash")
			if direction.x == 0:
				velocity.x = anim_tree.get("parameters/Dash/blend_position") * DASH_SPEED
				$DashTimer.start(0.5)
			else:
				velocity.x = direction.x * DASH_SPEED 
				$DashTimer.start(0.08)
			
			$DashCooldown.start(dash_cooldown)
			can_dash = false

	if can_move:
		move_and_slide()

	if get_parent().energy_bar.value >= 50:
		get_parent().energy_bar.tint_progress = Color(0.227, 0.514, 0.212)
	elif get_parent().energy_bar.value < 50 and get_parent().energy_bar.value >= 25:
		get_parent().energy_bar.tint_progress = Color(0.529, 0.314, 0.125)
	else:
		get_parent().energy_bar.tint_progress = Color(0.576, 0.184, 0.106)
	if Input.is_action_pressed("attack"):
		$RechargeTimer.start(recharge_time)
		if can_shoot:
			if get_parent().energy_bar.value > 0:
				get_parent().energy_bar.value -= 45 * delta
				pressed_time += delta 
				


const bolt = preload("res://instanced/bullet.tscn")


@onready var hit = $hit
var is_flipped = false
var pressed_time = 0.0
var bolt_size
var recharge_time = 2
var can_shoot = true
var regen_time = 10
var max_energy = 100
var charging = false



signal player_dead


func _input(event):
	if event.is_action_pressed("attack") and !global.in_dialogue:
			$Bolt.visible = true
			charging_attack = true
			if can_shoot:
				anim_state.travel("Charge")
	if event.is_action_released("attack") and !global.in_dialogue:
		if can_shoot:
			anim_state.travel("Shoot")
			shoot()
			$Bolt.visible = false
			charging_attack = false
			await $AnimationTree.animation_finished
		
			



		
		
	

func shoot():
	var bullet = bolt.instantiate()
	var muzzle
	if sprite.flip_h == true:
		muzzle = left_muzzle
		bullet.dir = "left"
	else:
		muzzle = right_muzzle
		bullet.dir = "right"
	get_parent().get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	if pressed_time >= 1.5:
		DAMAGE = 25
		bullet.size = "big"
		$GunCooldown.start(2)
		can_shoot = false
	elif pressed_time <= 0.5:
		DAMAGE = 15
		bullet.size = "small"
		$GunCooldown.start(1)
	else:
		DAMAGE = 10
		bullet.size = "default"
		$GunCooldown.start(1)
	attack.play()
	can_shoot = false
	if !charging:
		$RechargeTimer.start(recharge_time)
		charging = true
	pressed_time = 0






func _on_platform_detection_body_entered(body):
	is_on_platform = true
	platform = body


func _on_platform_detection_body_exited(body):
	is_on_platform = false
	platform = null


func _on_collision_shape_3d_child_entered_tree(body):
	if body.has_method("npc"):
		npc_in_range = true
	


func _on_collision_shape_3d_child_exiting_tree(body):
	if body.has_method("npc"):
		npc_in_range = false





func _on_dash_timer_timeout():
	dashing = false

	


func _on_dash_cooldown_timeout():
	can_dash = true


func _on_hurtbox_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		var tween = get_tree().create_tween()
		HEALTH -= 15
		hit.play()
		tween.tween_property(get_parent().health_ui,"value", HEALTH ,.3)
		if HEALTH <= 0:
			if can_die:
				dead = true
				can_move = false
				$AnimationPlayer.play("death")
				emit_signal("player_dead")
		#get_parent().health_ui.value = HEALTH
		$HealthRegen.start(regen_time)


func _on_recharge_timer_timeout():
	if sprite.flip_h == true:
		var tween = get_tree().create_tween()
		tween.tween_property(charge, "global_position", left.global_position, 0.05)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(charge, "global_position", right.global_position, 0.05)

	charge.visible = true
	var recharge_time
	if max_energy - get_parent().energy_bar.value >= 90:
		recharge_time = 2
	elif max_energy - get_parent().energy_bar.value < 90 and  max_energy - get_parent().energy_bar.value >= 50:
		recharge_time = 1
	else:
		recharge_time = 0.5
	var tween = get_tree().create_tween()
	tween.tween_property(get_parent().energy_bar, "value", max_energy , recharge_time)

	
	charge.visible = false
	can_shoot = true
	charging = false


func _on_health_regen_timeout():
	HEALTH += 5
	if HEALTH > MAX_HEALTH:
		HEALTH = MAX_HEALTH
	get_parent().health_ui.value = HEALTH
	if HEALTH < MAX_HEALTH:
		$HealthRegen.start(regen_time)
		


func _on_gun_cooldown_timeout():
	can_shoot = true
