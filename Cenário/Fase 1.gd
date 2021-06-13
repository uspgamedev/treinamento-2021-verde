extends Node2D

var score = 0
var i = 0

func _process(_delta):
	if score == 5 and i == 0:
		i = 1
		get_tree().paused = true
		$ColorRect/AnimationPlayer.play("FadeOut")
		yield(get_node("ColorRect/AnimationPlayer"), "animation_finished")
		get_tree().paused = false
		get_tree().change_scene("res:/WinGame.tscn")
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
