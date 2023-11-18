extends Node3D

var broken_rot = Vector3(-12,90,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	global.connect("update_quest" , break_pipe)
	$InteractUI.visible = false
	
func break_pipe():
	if global.quest["chapter2"]["q3"].active == true and is_instance_valid($InteractUI):
		$InteractUI.visible = true
		$GPUParticles3D.visible = true
		self.rotation.x = deg_to_rad(-12)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
