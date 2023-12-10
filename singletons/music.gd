extends Node


@onready var enemy
@onready var bgm = $AudioStreamPlayer
@onready var battle_bgm = load("res://assets/sounds/battle_bgm.mp3")
@onready var neutral_bgm = load("res://assets/sounds/main_bgm.mp3")


@onready var music_theme= {
	"Forest":load("res://assets/sounds/main_bgm.mp3") ,
	"Hub": load("res://assets/sounds/open-fields-aaron-paul-low-main-version-25198-02-16.mp3"),
	"Desert":load("res://assets/sounds/Epic Arabian Music  Desert Guard  by Ogdar Green.mp3") ,
	"City": load("res://assets/sounds/glimpse-of-euphoria-ian-aisling-main-version-24763-01-39.mp3"),
	"Snow": load("res://assets/sounds/open-fields-aaron-paul-low-main-version-25198-02-16.mp3"),
	"Lab": load("res://assets/sounds/cheat-codes-cinco-main-version-01-56-2929.mp3")
	}

var status
var weather



# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func ding():
	$QuestComplete.play()

func change_music(_status):
	status = _status
	match status:
		"neutral":
			bgm.stream = music_theme[global.curr_scene_name]
		"battle":
			bgm.stream = battle_bgm 
	if !bgm.playing:
		bgm.playing = true



func _process(delta):
	pass
