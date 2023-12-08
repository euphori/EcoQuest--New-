extends CharacterBody3D


@export var item_name : String
@export var chapter : String
@export var quest : String
@export var amount = 1

@export var hide = false

@onready var sprite = $Sprite3D
@onready var collision = $InteractUI/PlayerDetection/CollisionShape3D
@onready var label = $SubViewport/Label
@onready var manager = get_parent().get_parent().get_node("CharacterManager")

signal item_added
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$PickLabel.visible = false
	if hide:
		if global.quest[chapter][quest].active:
			collision.disabled = false
			self.visible = true 
		else:
			collision.disabled = true
			self.visible = false
	global.connect("update_quest" , show_item)
	global.connect("pickup_item", pick_up)
	
func pick_up(item, amm):
	if manager.nearest_interactable == self:
		$Sprite3D.visible = false
		manager.interactables.erase(self)
		label.text = str("+", amm , " " , item)
		$AnimationPlayer.play("pick")
		await $AnimationPlayer.animation_finished
		queue_free()

func show_item():
	if chapter != null and chapter != "" and global.quest[chapter][quest].active:
		collision.disabled = false
		self.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item_name != "":
		sprite.texture = load(global.item_texture[item_name])
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	
	move_and_slide()
