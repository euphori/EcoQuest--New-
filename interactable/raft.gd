extends StaticBody3D

@export_file("*tscn") var next_scene
@export var hide = false
@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
@onready var journal = get_parent().get_node("CharacterManager/Journal")
@onready var player = get_parent().get_node("CharacterManager/Kid")

@export_category("Dialogue")
@export var has_dialogue = false
@export var dialogue_resource : DialogueResource
@export var title = "start"
@export var need_to_charge = false

var charged = false
# Called when the node enters the scene tree for the first time.
func _ready():
	global.connect("update_quest", charge)
func _process(delta):
	if hide:
		if global.quest["chapter1"]["q4.5"].active or global.quest["chapter2"]["q1"].completed:
			self.visible = true
		else:
			self.visible = false

func charge():
	if global.quest["chapter4"]["q3"].active:
		
		$AnimationPlayer.play("charge")
		if $SubViewport/Control/TextureProgressBar.value >= 100:
			charged = true

func show_dialogue():
	if !global.in_dialogue:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, title)
		global.in_dialogue= true
