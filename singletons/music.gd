extends Node


@onready var enemy
@onready var bgm = $AudioStreamPlayer
@onready var battle_bgm = load("res://assets/sounds/battle_bgm.mp3")
@onready var neutral_bgm = load("res://assets/sounds/main_bgm.mp3")


var status
var weather



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func change_music(_status):
	status = _status
	match status:
		"neutral":
			bgm.stream = neutral_bgm
		"battle":
			bgm.stream = battle_bgm 
	if !bgm.playing:
		bgm.playing = true


func _process(delta):
	pass
