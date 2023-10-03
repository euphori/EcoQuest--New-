extends Area3D

var velocity = Vector3.ZERO
var speed = 5 

@onready var sprite = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("default")




func _physics_process(delta):
	#position.x += speed * delta
	#print(position)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
