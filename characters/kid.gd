extends "res://characters/movement_component.gd"

const bolt = preload("res://instanced/bullet.tscn")
@onready var left_muzzle = $LeftMarker
@onready var right_muzzle = $RightMarker
@onready var sprite = $Sprite3D
@onready var attack = $attack

var is_flipped = false
var pressed_time = 0.0
var bolt_size
var recharge_time = 1.5
var can_shoot = true
var regen_time = 10

func _process(delta):
	if Input.is_action_pressed("attack"):
		pressed_time += delta 
		attack.play()
		get_parent().energy_ui.value = ENERGY
		
	if Input.is_action_just_released("attack") and ENERGY != 0 and can_shoot:
		
		var muzzle
		if sprite.flip_h == true:
			muzzle = left_muzzle
			is_flipped = true
		else:
			muzzle = right_muzzle
			is_flipped = false
		var bullet = bolt.instantiate()
		
		get_parent().get_parent().add_child(bullet)
		if is_flipped:
			bullet.sprite.flip_v = true
		else:
			bullet.sprite.flip_v = false
		
		bolt_size = pressed_time
		
		if pressed_time > 1.5 and ENERGY == 25:
			bolt_size = 1.5
			ENERGY -= 25
			
			get_parent().energy_ui.value = ENERGY
			can_shoot = false
		elif pressed_time < 0.5:
			bolt_size = 0.5
			ENERGY -= 10
		else:
			ENERGY -= 10
		$RechargeTimer.start(recharge_time)
		get_parent().energy_ui.value = ENERGY
		bullet.scale = Vector3(bolt_size,bolt_size,bolt_size)
		pressed_time = 0
		bullet.global_position = muzzle.global_position

		
	
	


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
	velocity.x = move_toward(velocity.x, 0 , SPEED)
	


func _on_dash_cooldown_timeout():
	can_dash = true


func _on_hurtbox_area_entered(area):
	print(get_parent().get_name())
	if area.get_parent().get_name() == "Enemy":
		HEALTH -= 20
		get_parent().health_ui.value = HEALTH
		$HealthRegen.start(regen_time)


func _on_recharge_timer_timeout():
	get_parent().energy_ui.value = ENERGY
	ENERGY = 25
	can_shoot = true


func _on_health_regen_timeout():
	HEALTH += 5
	if HEALTH > MAX_HEALTH:
		HEALTH = MAX_HEALTH
	get_parent().health_ui.value = HEALTH
	if HEALTH < MAX_HEALTH:
		$HealthRegen.start(regen_time)
