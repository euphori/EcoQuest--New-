extends Area3D

var velocity = Vector3.ZERO
var speed = 5 
enum{
	BIG,
	DEFAULT,
	SMALL
}

var size 
var dir
@onready var sprite = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false



func _physics_process(delta):
	
	match size:
		"big":
			if dir == "right":
				$AnimationPlayer.play("big_charge")
			else:
				$AnimationPlayer.play("big_charge_right")
		"default":
			if dir == "right":
				$AnimationPlayer.play("default")
			else:
				$AnimationPlayer.play("default_right")
		"small":
			if dir == "right":
				$AnimationPlayer.play("small_charge")
			else:
				$AnimationPlayer.play("small_charge_right")
	visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


