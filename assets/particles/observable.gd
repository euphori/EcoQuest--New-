extends Node


@onready var observe_bar = $ObserveBar
@onready var observe_prog = $SubViewport/Control/TextureProgressBar
@onready var manager = get_parent().get_parent().get_node("CharacterManager")

var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.quest["chapter3"]["q2"].active:
		self.visible = true
	else:
		self.visible = false
	global.connect("update_quest", show)

func _input(event):
	pass

func show():
	if global.quest["chapter3"]["q2"].active:
		self.visible = true

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("interact") and $InteractUI.player_near and !done and manager.nearest_interactable == self:
		observe_prog.value += 25 * delta
		if observe_prog.value >= 100:
			done = true
			global.items["Data"] += 1
			global.emit_signal("update_quest")
			observe_bar.queue_free()
			$InteractUI.get_node("Arrow").queue_free()
