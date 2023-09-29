extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jumping = false
var busy = false
var active
var pushing = false
var npc_in_range = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if npc_in_range == true:
		if Input.is_action_just_pressed("talk"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "start")


	move_and_slide()
		

func npc():
	pass

