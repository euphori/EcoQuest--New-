extends Node3D

@export var HP = 100

@export_category("Item Spawned")
@export var drop_item = true
@export var item_name : String
@export var texture_path : String
@export var _amount = 1

@onready var hp_bar = $SubViewport/HealthProgress
@onready var item = load("res://interactable/item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawn():
	var _item = item.instantiate()
	_item.item_name = item_name
	_item.amount = _amount
	get_parent().get_node("Items").add_child(_item)

	_item.global_position = self.global_position
	_item.sprite.texture = load(texture_path)
	
func _on_hurtbox_area_entered(area):
	if HP > 0:
		HP -= 50
		var tween = get_tree().create_tween()
		tween.tween_property(hp_bar , "value" , HP , .5)
		if HP <= 0 :
			if drop_item:
				spawn()
			queue_free()
	else:
		queue_free()
