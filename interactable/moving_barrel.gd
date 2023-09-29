extends StaticBody3D

@onready var mesh = $SM_Barrel_LOD3

func _ready():
	$AnimationPlayer.play("move_left")
