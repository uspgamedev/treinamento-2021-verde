extends Node2D

var score = 0

func _process(_delta):
	if score == 1:
		$ColorRect/AnimationPlayer.play("FadeOut")
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://WinGame.tscn")
		
