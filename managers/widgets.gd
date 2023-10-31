extends Control

@onready var camera_controller = $CameraController
@onready var fps = $FPS
@onready var kid_stats = $Stats/Kid
@onready var robot_stats = $Stats/Robot
@onready var kid = get_parent().get_node("Kid")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps.text = str("FPS: ",Engine.get_frames_per_second(),"ms")
	
	kid_stats.text = str("Speed: ", kid.SPEED, "\nGlobal Position: ", kid.global_position, "\nOn Floor: " , kid.is_on_floor(), "\nCan Move: ", kid.can_move,"\nJumping: ", kid.jumping)
