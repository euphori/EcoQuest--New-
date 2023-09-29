extends Control


func _on_controller_pressed():
	$ControllerGroup.visible = true
	$AudioGroup.visible = false
	$Mechanics.visible = false
	
func _on_audio_pressed():
	$AudioGroup.visible = true
	$ControllerGroup.visible = false
	$Mechanics.visible = false


func _on_video_pressed():
	$AudioGroup.visible = false
	$ControllerGroup.visible = false
	$Mechanics.visible = false


func _on_mechanics_pressed():
	$Mechanics.visible = true
	$AudioGroup.visible = false
	$ControllerGroup.visible = false
	
