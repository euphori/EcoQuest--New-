extends CharacterBody3D


@export var item_name : String
@export var assigned_quest : String
@export var hide = false

@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
signal item_added
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if hide:
		if global.active_quest[assigned_quest]:
			collision.disabled = false
			self.visible = true 
		else:
			collision.disabled = true
			self.visible = false
	
	move_and_slide()
