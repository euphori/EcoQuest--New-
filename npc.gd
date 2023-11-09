extends CharacterBody3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D


@export_category("Dialogue")
@export var title: String = "start"
@export var dialogue_resource: DialogueResource
@export_category("Quest Connection")
@export var has_event : bool
@export var chapter_name : String
## quest that needs to be completed
@export var completed_quest : String



var jumping = false
var busy = false
var active
var pushing = false
var player_in_range
var player
var in_dialogue


func _ready():
	if global.quest["chapter1"]["q2"].completed and get_parent().name == "Forest":
		self.global_position = get_parent().get_node("Dock").global_position
	$InteractUI.connect("talk" , talk)
	GlobalDialogue.connect("dialogue_ended", return_camera)
	if has_event:
		global.connect("update_quest" , do_event)



func do_event():
	if chapter_name == "chapter1" and completed_quest == "q2" and global.quest["chapter1"]["q3"].completed == false:
		if global.quest[chapter_name][completed_quest].completed:
			return_camera()
			self.global_position = get_parent().get_node("Dock").global_position

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
	if player != null:
		player.get_parent().camera.current = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()




