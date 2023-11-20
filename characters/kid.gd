extends "res://characters/movement_component.gd"

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

func _process(delta):
	
	if get_parent().energy_bar.value >= 50:
		get_parent().energy_bar.tint_progress = Color(0.227, 0.514, 0.212)
	elif get_parent().energy_bar.value < 50 and get_parent().energy_bar.value >= 25:
		get_parent().energy_bar.tint_progress = Color(0.529, 0.314, 0.125)
	else:
		get_parent().energy_bar.tint_progress = Color(0.576, 0.184, 0.106)
	if Input.is_action_pressed("attack"):
		$RechargeTimer.start(recharge_time)
		if can_shoot:
			$AnimationPlayer.play("charge")
			if get_parent().energy_bar.value > 0:
				
				get_parent().energy_bar.value -= 45 * delta
				pressed_time += delta 
				
	if Input.is_action_just_released("attack") and can_shoot:
		shoot()
		
	

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
		bullet.size = "big"
		$GunCooldown.start(2)
		can_shoot = false
	elif pressed_time <= 0.5:
		bullet.size = "small"
		$GunCooldown.start(1)
	else:
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
	velocity.x = move_toward(velocity.x, 0 , SPEED)
	


func _on_dash_cooldown_timeout():
	can_dash = true


func _on_hurtbox_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		var tween = get_tree().create_tween()
		print("HIT")
		HEALTH -= 5
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
