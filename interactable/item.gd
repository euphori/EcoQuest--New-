extends Node3D


@export var item_name : String

@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.question1_complete:
		collision.disabled = false
		self.visible = true 
	else:
		collision.disabled = true
		self.visible = false
