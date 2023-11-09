extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	global.connect("transistion" , fade_out_in)


func fade_out_in():
	$AnimationPlayer.play("fade_to_black")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("fade_to_normal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
