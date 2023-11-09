extends CharacterBody3D


@export var item_name : String
@export var chapter : String
@export var quest : String

@export var hide = false

@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
signal item_added
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if hide:
		if global.quest[chapter][quest].active:
			collision.disabled = false
			self.visible = true 
		else:
			collision.disabled = true
			self.visible = false
	global.connect("update_quest" , show_item)


func show_item():

	collision.disabled = false
	self.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	
	move_and_slide()
