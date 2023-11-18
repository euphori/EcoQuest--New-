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
@onready var manager = get_parent().get_node("CharacterManager")
## quest that needs to be completed
@export var completed_quest : String
@onready var screen_trans = get_parent().get_node("CanvasLayer/AnimationPlayer")


var jumping = false
var busy = false
var active
var pushing = false
var player_in_range
var player



func _ready():
	if get_parent().name == "Forest" and self.name == "Lucas":
		if global.quest["chapter1"]["q2"].completed and !global.quest["chapter3"]["q1"].active :
			self.global_position = get_parent().get_node("Dock").global_position
		elif global.quest["chapter3"]["q1"].active or global.quest["chapter2"]["q5"].completed:
			self.global_position = get_parent().get_node("Observe").global_position
		if check_completed_quest("chapter1") == true:
			title = "chapter3"
	elif get_parent().name == "Hub" and self.name == "Lucas":
		if  global.quest["chapter1"]["q5"].active == false:
			self.queue_free()
	
	
	if get_parent().name == "Hub" and self.name == "Harper":
		if global.quest["chapter2"]["q4"].completed == false:
			self.queue_free()
	$InteractUI.connect("talk" , talk)
	GlobalDialogue.connect("dialogue_ended", return_camera)
	if has_event:
		global.connect("update_quest" , do_event)
	GlobalDialogue.connect("open_shop" , open_shop)


func check_completed_quest(chapter):
		for i in global.quest[chapter]:
			if !global.quest[chapter][i].completed:
				return false
			return true

func open_shop():
	if is_instance_valid($Shop):
		$Shop.visible = true
	

func _input(event):
	if event.is_action_pressed("esc") and is_instance_valid($Shop) and $Shop.visible:
		$Shop.visible = false
func do_event():
	if chapter_name == "chapter1" and completed_quest == "q2" and global.quest["chapter1"]["q3"].completed == false:
		if global.quest[chapter_name][completed_quest].completed:
			return_camera()
			screen_trans.play("fade_to_black")
			await screen_trans.animation_finished
			self.global_position = get_parent().get_node("Dock").global_position
			screen_trans.play("fade_to_normal")

func talk():
	var dir = global_position.direction_to(player.global_position)
	if dir.x > 0:
		$Sprite3D.flip_h = true
	else:
		$Sprite3D.flip_h = false
	if !global.in_dialogue:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)
		global.in_dialogue= true
	#var balloon = get_parent().get_node("ExampleBalloon/Balloon")
	#balloon.global_position = Vector2($Marker3D.global_position.x,$Marker3D.global_position.y)
	camera.current = true


func return_camera():
	if manager.nearest_interactable == self:
		if global.in_dialogue:
			if get_parent().get_node("ExampleBalloon/AnimationPlayer") != null:
				var anim_player = get_parent().get_node("ExampleBalloon/AnimationPlayer")
				anim_player.play("hide")
				await  anim_player.animation_finished
			global.in_dialogue= false
			if player != null:
				player.get_parent().camera.current = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()




