extends StaticBody3D

@export_file("*tscn") var next_scene
@export var hide = false
@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
@onready var journal = get_parent().get_node("CharacterManager/Journal")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	if hide:
		if global.completed_quest["tutorial"]:
			collision.disabled = false
			self.visible = true 
		else:
			collision.disabled = true
			self.visible = false
			
func _input(event):
	if event.is_action_pressed("interact") and $InteractUI.player_near and visible:
		journal.map.initialize_map()
		journal.show_map()
