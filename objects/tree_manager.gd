extends Node3D


@onready var slider = $CanvasLayer/HSlider


var val = 0


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_trees():
	for i in get_child_count():
		if get_child(i) is StaticBody3D:
			var rand = randi_range(0,val + 1)
			if rand < 10 and val < 70 and  val < 98:
				get_child(i).curr_state = "bald"
				get_child(i).update_state()
			elif rand > 11 and rand < 70 and  val < 98:
				get_child(i).curr_state = "trim"
				get_child(i).update_state()
			elif rand > 70:
				get_child(i).curr_state = "full"
				get_child(i).update_state()
			elif val >= 98:
				get_child(i).curr_state = "full"
				get_child(i).update_state()


func _on_h_slider_value_changed(value):
	val = value
	$CanvasLayer/Label.text = str(val)
	update_trees()
