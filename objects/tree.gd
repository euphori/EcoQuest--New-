extends StaticBody3D



@onready var state = {"bald" : $Bald , "trim" : $Trim, "full":$Full}

var curr_state
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_size()
	


func randomize_size():
	var rand_size = randf_range(0,1)
	var rand_rot = randi_range(0,180)
	scale.x += rand_size
	scale.y += rand_size
	scale.z += rand_size
	rotate_y(rand_rot)
	
	

func update_state():
	for i in state:
		if i == curr_state:
			state[curr_state].visible = true
			if state[curr_state].get_child_count() > 1:
				var rand = randi_range(0, state[curr_state].get_child_count() - 1)
				var mesh 
				for x in state[curr_state].get_child_count():
					if x == rand:
						mesh = state[curr_state].get_node(str(rand))
						mesh.visible = true
					else:
						mesh = state[curr_state].get_node(str(x))
						mesh.visible = false
		else:
			
			state[i].visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
