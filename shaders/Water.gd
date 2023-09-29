extends Node3D

@export var time = 5
@export var intensity = Vector3(0,0.5,0)
@export var rising_enabled = false

var old_pos 
var t = 0.0
var rising = false
# Called when the node enters the scene tree for the first time.
func _ready():
	old_pos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if rising and rising_enabled:
		t += delta * 0.4
		global_position = old_pos.lerp(old_pos+intensity,t)
		if global_position == (old_pos + intensity):
			rising = false
			old_pos = global_position 
			$Timer.start(time)

func _on_timer_timeout():
	global_position.y += intensity.y
	rising = true

	
