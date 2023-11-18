extends StaticBody3D

@export_file("*tscn") var next_scene
@export var hide = false
@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
@onready var journal = get_parent().get_node("CharacterManager/Journal")
@onready var player = get_parent().get_node("CharacterManager/Kid")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	if hide:
		if global.quest["chapter1"]["q4.5"].active or global.quest["chapter2"]["q1"].completed:
			self.visible = true
		else:
			self.visible = false
