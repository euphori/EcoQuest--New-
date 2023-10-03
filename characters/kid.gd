extends "res://characters/movement_component.gd"

const bolt = preload("res://instanced/bullet.tscn")
@onready var left_muzzle = $LeftMarker
@onready var right_muzzle = $RightMarker
@onready var sprite = $Sprite3D

var is_flipped = false
var pressed_time = 0.0
var bolt_size

func _process(delta):
	if Input.is_action_pressed("attack"):
		pressed_time += delta 
		
	if Input.is_action_just_released("attack"):
		
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
		
		if pressed_time > 1.5:
			bolt_size = 1.5
		elif pressed_time < 0.5:
			bolt_size = 0.5
		bullet.scale = Vector3(bolt_size,bolt_size,bolt_size)
		print(bullet.scale)
		print(pressed_time)
		pressed_time = 0
		bullet.global_position = muzzle.global_position
		print(pressed_time)
		
		

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

