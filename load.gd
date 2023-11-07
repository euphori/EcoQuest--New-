extends Control


var next_scene  = global.next_scene

var progress = []
var scene_load_status

@onready var progress_bar = $ProgressBar

func _ready():
	ResourceLoader.load_threaded_request(next_scene)


func set_scene(_next_scene):
	next_scene = _next_scene


func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(next_scene,progress)
	match scene_load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var tween = get_tree().create_tween()
			tween.tween_property(progress_bar,"value", progress[0] * 100 , 0.5)
			$Percent.text = str(progress_bar.value, "%")
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			var tween = get_tree().create_tween()
			tween.tween_property(progress_bar,"value", progress[0] * 100, 0.1)
			$Percent.text = str(progress_bar.value, "%")
			if progress_bar.value >= 100:
				get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("Error. Invalid Resource")
