extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("MarginContainer/Texto/Press-ENTER-to-start/ENTERPlayer").play("TextoMainMenu")
	get_node("MarginContainer/Tocha/TextureRect/Sprite/TochaPlayer").play("TochaMainMenu")
	get_node("MarginContainer/Tocha/TextureRect2/Light2D/LuzPlayer").play("LuzMainMenu")

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_node("MarginContainer/Fade/FadePlayer").play("Fade")
		yield(get_tree().create_timer(1.2), "timeout")
		get_tree().change_scene("res://Fase 1.tscn")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
