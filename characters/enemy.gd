extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8
const ACCELERATION = 150
const MAX_SPEED = 7
const AGGRO_RANGE = 15



@export var path_to_player:NodePath

@onready var player = get_node(path_to_player)
@onready var jump_timer = $JumpCooldown

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state = CHASE
var jumping = false
var jump_cd = 3
var can_jump = true


enum{
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	JUMP
}


func _ready():
	state =  CHASE
	


func _physics_process(delta):
	
	$Stats.text = str("Velocity: ", velocity, "\nIs Jumping: ", jumping, "\nJump Cooldown: ",int($JumpCooldown.time_left))
	
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
			if abs(distance.x) > 4 and is_on_floor():
				velocity.x += destination.x * ACCELERATION * delta 
				velocity = velocity.limit_length(MAX_SPEED)
				
				if velocity.x < 0 and $LeftRay.is_colliding():
					state = JUMP
				elif velocity.x > 0 and $RightRay.is_colliding():
					state = JUMP
				if abs(velocity.x) != 0:
					$AnimationPlayer.play("run")
				else:
					$AnimationPlayer.play("idle")
					velocity.x = move_toward(velocity.x, 0, SPEED)
			elif abs(distance.x) > 2 and is_on_floor():
				state = ATTACK
			elif abs(distance.x) >= AGGRO_RANGE:
				state = IDLE
				velocity.x = move_toward(velocity.x, 0, SPEED)
		ATTACK:
			$Label3D.text = str("State: ATTACK")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimationPlayer.play("attack")
			await $AnimationPlayer.animation_finished
			state = CHASE
			
		JUMP:
			$Label3D.text = str("State: JUMP")
			jump()
			
		
	
	if velocity.x  < 0:
		$Sprite3D.flip_h = true
	elif velocity.x  > 0 :
		$Sprite3D.flip_h = false
	
	move_and_slide()

func jump():
	velocity.x
	if is_on_floor():
		jumping = false
	if not jumping and can_jump:
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
