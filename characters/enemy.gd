extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 8
const ACCELERATION = 15
const MAX_SPEED = 7

const KNOCKBACK_FORCE = 40
var DASH_SPEED = 20

@export_category("Dialogue")
@export var dialogue_resource : DialogueResource
@export var title : String = "start"
@export_category("Quest")
@export var add_on_kill : bool
@export var related_chapter: String
@export var related_quest: String

@export_category("Item Spawned")
@export var drop_item = true
@export var item_name = "Scraps"
@export var _amount = 2
@onready var item = load("res://interactable/item.tscn")



@onready var player = get_parent().get_node("CharacterManager/Kid")
@export_category("Stats")
@export var health = 100
@export var AGGRO_RANGE = 15
@export var ATTACK_RANGE = 3
@export var MIN_ATTACK_RANGE = 1
@onready var jump_timer = $JumpCooldown
@onready var hp_bar = $SubViewport/HealthProgress

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state = CHASE
var jumping = false
var jump_cd = 3
var can_jump = true
var staggering = false
var can_move = true
var attacking = false
var dashing
var timer_started
var dead
var death_quest_trigger = ["",""]
var chosen = false
var chosen_dir = Vector3.ZERO


signal engage

enum{
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	JUMP,
	STAGGER,
	DASH
}


func _ready():
	if global.quest[related_chapter][related_quest].completed:
		queue_free()
	if global.enemy_cleared.keys().has(get_parent().name):
		if global.enemy_cleared[get_parent().name]:
			queue_free()
	GlobalMusic.enemy = self
	state =  CHASE
	

func spawn():
	var _item = item.instantiate()
	_item.item_name = item_name
	_item.amount = _amount
	get_parent().get_node("Items").add_child(_item)
	_item.global_position = self.global_position


func start_dialogue():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)


func _physics_process(delta):
	
	$Stats.text = str("Health: ", health,"\nVelocity: ", velocity, "\nIs Jumping: ", jumping, "\nJump Cooldown: ",int($JumpCooldown.time_left))
	

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jumping = false
	
	if player.dead and dead:
		GlobalMusic.change_music("neutral")
		state = IDLE
	
	match state:
		IDLE:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimationPlayer.play("idle")
			$Label3D.text = str("State: IDLE ")
		CHASE:
			
			$Label3D.text = str("State: CHASE")
			if is_on_floor():
				var destination = self.global_position.direction_to(player.global_position)
				var distance = self.global_position - player.global_position
				if  abs(distance.z) > .5 and is_on_floor() and can_move:
					axis_lock_linear_z = false
					velocity.z += destination.z * SPEED * delta
				elif abs(distance.z) < .5  and is_on_floor() and can_move:
					velocity.z += move_toward(velocity.z , 0, SPEED)
				if abs(distance.x) > ATTACK_RANGE and is_on_floor() and can_move:
					velocity.x += destination.x * ACCELERATION * delta 
					velocity = velocity.limit_length(SPEED)
				elif abs(distance.x) < MIN_ATTACK_RANGE and is_on_floor() and can_move:
					destination =  player.global_position.direction_to(self.global_position)
					velocity.x += destination.x * ACCELERATION * delta 
					velocity = velocity.limit_length(SPEED)
				print(distance.z)
				if abs(distance.x) <= ATTACK_RANGE and abs(distance.x) >= MIN_ATTACK_RANGE and is_on_floor() and !staggering and abs(distance.z) <= 0.7 and !dashing:
					state = ATTACK
					axis_lock_linear_z = true
				elif abs(distance.x) >= AGGRO_RANGE:
					state = IDLE
					velocity.x = move_toward(velocity.x, 0, SPEED)
				#velocity.x += destination.x * ACCELERATION * delta 
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
		ATTACK:
			var dir = self.global_position.direction_to(player.global_position)
			$Label3D.text = str("State: ATTACK")
			if dir.x > 0 and !attacking and !dashing:
				$AnimationPlayer.play("attack_right")
				attacking = true
			elif dir.x < 0 and !attacking and !dashing:
				$AnimationPlayer.play("attack_left")
				attacking = true
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
			if self.name == "Enemy":
				await $AnimationPlayer.animation_finished
				attacking = false
				state = CHASE
				
		DASH:
			$Label3D.text = str("State: DASH")

			var distance = self.global_position.distance_to(player.global_position)
			if !chosen:
				chosen_dir = player.global_position
				chosen = true
			var dir = self.global_position.direction_to(chosen_dir)
			if dashing:
				if !timer_started:
					$DashTimer.start(.5)
					timer_started = true
				velocity.x = dir.x * DASH_SPEED
			
				
				
		JUMP:
			$Label3D.text = str("State: JUMP")
			jump()
		STAGGER:
			$AnimationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$Label3D.text = str("State: STAGGER")
			if !staggering:
				$StaggerTimer.start(1)
			staggering = true


		
	
	if velocity.x  < 0:
		$Sprite3D.flip_h = true
	elif velocity.x  > 0 :
		$Sprite3D.flip_h = false
	
	move_and_slide()

func jump():
	velocity.x
	if is_on_floor():
		jumping = false
	if not jumping and can_jump and !staggering and !dashing:
		var direction = self.global_position.direction_to(player.global_position)
		velocity.y += JUMP_VELOCITY
		jumping = true
		jump_timer.start(jump_cd)
		if $LeftRay.is_colliding() and $Sprite3D.flip_h:
			velocity.x = move_toward(velocity.x,direction.x * ACCELERATION,1)
		elif $RightRay.is_colliding() and not $Sprite3D.flip_h:
			velocity.x = move_toward(velocity.x,direction.x * ACCELERATION,1)
		
		state = CHASE
		can_jump = false
		

func dash():
	if !dashing:
		dashing = true
		state = DASH
	

func die():
	dead = true
	if drop_item:
		spawn()
	if name == "Enemy":
		global.enemy_cleared[get_parent().name] = true
		
	if death_quest_trigger[0] != "" and  death_quest_trigger[1] != "":
		##0 is chapter 1 is quest id
		global.quest[death_quest_trigger[0]][death_quest_trigger[1]].completed = true
		global.quest[death_quest_trigger[0]][death_quest_trigger[1]].active = false
		global.emit_signal("update_quest")
	
	if add_on_kill:
		global.curr_killcount += 1
		var quest = global.get_active_quest()
		print("QUEST: " , quest)
		
		if quest.kill_req <= global.curr_killcount:
			quest.active = false
			quest.completed = true
			global.emit_signal("update_quest")
	queue_free()

func hurt():
	health -= 25
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar, "value", health, 0.5)
	knockback()
	if health <= 0:
		die()
		

func attack():
	state = ATTACK


func knockback():
	var direction = player.global_position.direction_to(self.global_position)
	velocity.x = direction.x * KNOCKBACK_FORCE
	$StaggerTimer.start(1)
	$AnimationPlayer.stop()
	state = STAGGER
	

	
	
	

func _on_player_detection_body_entered(body):
	if GlobalMusic.status != "battle":
		GlobalMusic.change_music("battle")
	if body == player and !dashing and !staggering and !player.dead:
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




func stop_dash():
	attacking = false
	dashing = false
	state = STAGGER


func _on_dash_timer_timeout():
	dashing = false
	timer_started = false
	chosen = false
