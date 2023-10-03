extends Node3D


@export var item_name : String
@export var hide = false

@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
signal item_added

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hide:
		if global.active_quest["q1"]:
			collision.disabled = false
			self.visible = true 
		else:
			collision.disabled = true
			self.visible = false
