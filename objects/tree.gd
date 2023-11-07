extends StaticBody3D



@onready var state = {"bald" : $Bald , "trim" : $Trim, "full":$Full}
@onready var growth_timer = $GrowthTimer

@export var growth_level = 5
@export var grow_time = 10
@export var start_as_seed = false

var growing
var curr_state
var max_scale
var trim_mesh
var full_mesh
var rand
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_size()
	#$InteractUI.visible = false
	rand = randi_range(0, state["trim"].get_child_count() - 1)
	if start_as_seed:
		max_scale = scale
		scale = Vector3(.1,.1,.1)
		$InteractUI.scale = Vector3(20,20,20)
		$InteractUI.position.y += 5
		$InteractUI.rotation = -rotation
		pick_mesh()

	
	
	
func randomize_size():
	
	var rand_size = randf_range(0,1)
	var rand_rot = randi_range(0,180)
	scale.x += rand_size
	scale.y += rand_size
	scale.z += rand_size
	rotate_y(rand_rot)
	
	
	


func update_growth():
	if start_as_seed and growing and scale < max_scale:
		var tween = get_tree().create_tween()
		var scale_to_add = scale +  Vector3(0.15,0.15,0.15)
		tween.tween_property(self,"scale",scale_to_add, 2)
		growth_level += 1
		growth_timer.start(grow_time)
	elif scale >= max_scale:
		growing = false
	if growing and growth_level > 4 and growth_level < 7 and scale < max_scale:
		curr_state = "trim"
		pick_mesh()
	elif growing and growth_level >=  8 and scale < max_scale:
		curr_state = "full"
		pick_mesh()
	


func get_state():
	for i in state:
		if i == curr_state:
			return state[i]


func update_state():
	if state != null:
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
				if i != "seed":
					state[i].visible = false

func pick_mesh():

	if curr_state == "trim" and trim_mesh == null:
		for i in state:
			if i == curr_state:
				state[curr_state].visible = true
				if state[curr_state].get_child_count() > 1:
					
					var mesh 
					for x in state[curr_state].get_child_count():
						if x == rand:
							mesh = state[curr_state].get_node(str(rand))
							mesh.visible = true
							trim_mesh = mesh
						else:
							mesh = state[curr_state].get_node(str(x))
							mesh.visible = false
			else:
				state[i].visible = false
	elif curr_state == "full" and full_mesh == null:
		for i in state:
			if i == curr_state:
				state[curr_state].visible = true
				if state[curr_state].get_child_count() > 1:
					var mesh 
					for x in state[curr_state].get_child_count():
						if x == rand:
							mesh = state[curr_state].get_node(str(rand))
							mesh.visible = true
							trim_mesh = mesh
						else:
							mesh = state[curr_state].get_node(str(x))
							mesh.visible = false
			else:
				state[i].visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_growth_timer_timeout():
	update_growth()
	
	


func _on_interact_ui_grow():
	if start_as_seed:
		$InteractUI.queue_free()
		growing = true
		growth_timer.start(grow_time)
	
