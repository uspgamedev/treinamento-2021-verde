extends Node2D

func _ready():
	get_node("MarginContainer/Texto/Press-ENTER-to-start/ENTERPlayer").play("TextoMainMenu")
	get_node("MarginContainer/Tocha/TextureRect/Sprite/TochaPlayer").play("TochaMenu")
	get_node("MarginContainer/Tocha/TextureRect2/Light2D/LuzPlayer").play("LuzMainMenu")

func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		get_node("MarginContainer/Fade/FadePlayer").play("Fade")
		yield(get_tree().create_timer(1.2), "timeout")
		get_tree().change_scene("res://Fase 1.tscn")
