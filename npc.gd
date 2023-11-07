extends CharacterBody3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D



@export var title: String = "start"
@export var dialogue_resource: DialogueResource



var jumping = false
var busy = false
var active
var pushing = false
var player_in_range
var player
var in_dialogue

func _ready():
	$InteractUI.connect("talk" , talk)
	Dialogue.connect("dialogue_ended", return_camera)


func talk():
	if !in_dialogue:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)
		in_dialogue = true
	#var balloon = get_parent().get_node("ExampleBalloon/Balloon")
	#balloon.global_position = Vector2($Marker3D.global_position.x,$Marker3D.global_position.y)
	camera.current = true


func return_camera():
	if get_parent().get_node("ExampleBalloon/AnimationPlayer") != null:
		var anim_player = get_parent().get_node("ExampleBalloon/AnimationPlayer")
		print(anim_player)
		anim_player.play("hide")
		await  anim_player.animation_finished
	in_dialogue = false
	player.get_parent().camera.current = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()




