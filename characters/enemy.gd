extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 8
const ACCELERATION = 150
const MAX_SPEED = 7
const AGGRO_RANGE = 15
const KNOCKBACK_FORCE = 40


@export var path_to_player:NodePath
@export var health = 5

@onready var player = get_node(path_to_player)
@onready var jump_timer = $JumpCooldown

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state = CHASE
var jumping = false
var jump_cd = 3
var can_jump = true
var staggering = false
var can_move = true
var attacking = false

enum{
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	JUMP,
	STAGGER
}


func _ready():
	state =  CHASE
	


func _physics_process(delta):
	
	$Stats.text = str("Health: ", health,"\nVelocity: ", velocity, "\nIs Jumping: ", jumping, "\nJump Cooldown: ",int($JumpCooldown.time_left))
	

	if not is_on_floor():

		velocity.y -= gravity * delta
	else:
		jumping = false
	match state:
		IDLE:
			if !GlobalbgMusic.playing:
				GlobalbgMusic.play()
			GlobalbgMusicAttack.stop()
			
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimationPlayer.play("idle")
			$Label3D.text = str("State: IDLE ")
		CHASE:
			
			$Label3D.text = str("State: CHASE")
			var destination = self.global_position.direction_to(player.global_position)
			var distance = self.global_position - player.global_position
			if  abs(distance.z) > 0 and is_on_floor() and can_move:
				velocity.z += destination.z * 5 * delta
				
			if abs(distance.x) > 4 and is_on_floor() and can_move:
				velocity.x += destination.x * ACCELERATION * delta 
				
				velocity = velocity.limit_length(MAX_SPEED)
				
				if velocity.x < 0 and $LeftRay.is_colliding():
					state = JUMP
				elif velocity.x > 0 and $RightRay.is_colliding():
					state = JUMP
				if velocity != Vector3.ZERO:
					$AnimationPlayer.play("run")
					attacking = false
				else:
					$AnimationPlayer.play("idle")
					velocity.x = move_toward(velocity.x, 0, SPEED)
			elif abs(distance.x) > 2 and is_on_floor() and !staggering and abs(distance.z) < 0.5:
				state = ATTACK
			elif abs(distance.x) >= AGGRO_RANGE:
				state = IDLE
				velocity.x = move_toward(velocity.x, 0, SPEED)
		ATTACK:
			var dir = self.global_position.direction_to(player.global_position)
			$Label3D.text = str("State: ATTACK")
			if dir.x > 0 and !attacking:
				$AnimationPlayer.play("attack_right")
				attacking = true
			elif dir.x < 0 and !attacking:
				$AnimationPlayer.play("attack_left")
				attacking = true
			if self.name == "SawRobot":
				velocity.x += dir.x * ACCELERATION * delta 
				velocity = velocity.limit_length(SPEED * 5)
			else:
				
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
			await $AnimationPlayer.animation_finished
			state = CHASE
			attacking = false

			
		JUMP:
			$Label3D.text = str("State: JUMP")
			jump()
		STAGGER:
			("State: STAGGER")
			staggering = true	
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		
	
	if velocity.x  < 0:
		$Sprite3D.flip_h = true
	elif velocity.x  > 0 :
		$Sprite3D.flip_h = false
	
	move_and_slide()

func jump():
	velocity.x
	if is_on_floor():
		jumping = false
	if not jumping and can_jump and !staggering:
		var direction = self.global_position.direction_to(player.global_position)
		velocity.y += JUMP_VELOCITY
		jumping = true
		jump_timer.start(jump_cd)
		if $LeftRay.is_colliding() and $Sprite3D.flip_h:
			print("LEFT COLLIDING")
			velocity.x = move_toward(velocity.x,direction.x * ACCELERATION,1)
		elif $RightRay.is_colliding() and not $Sprite3D.flip_h:
			velocity.x = move_toward(velocity.x,direction.x * ACCELERATION,1)
		
		state = CHASE
		print(velocity.x)
		can_jump = false
		

func hurt():
	health -= 1
	knockback()
	if health <= 0:
		GlobalbgMusicAttack.stop()
		GlobalbgMusic.play()
		queue_free()
		
		
func knockback():
	var direction = player.global_position.direction_to(self.global_position)
	velocity.x = direction.x * KNOCKBACK_FORCE
	$StaggerTimer.start(1)
	$AnimationPlayer.stop()
	state = STAGGER
	

	
	
	

func _on_player_detection_body_entered(body):
	GlobalbgMusic.stop()
	if !GlobalbgMusicAttack.playing:
		GlobalbgMusicAttack.play()
	if body == player:
		state = CHASE
 

func _on_player_detection_body_exited(body):
	pass
	#if body == player:
		#state = IDLE


func _on_jump_cooldown_timeout():
	can_jump = true


func _on_hurtbox_area_entered(area):
	hurt()
	


func _on_stagger_timer_timeout():
	can_move = true
	staggering = false
	state = CHASE


func _on_hurtbox_body_entered(body):
	pass # Replace with function body.
