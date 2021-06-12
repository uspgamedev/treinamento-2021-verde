extends Node

func _ready():
	get_node("Control/Texto/ENTERPlayer").play("TextoMainMenu")
	get_node("Control/Tocha/Sprite/TochaPlayer").play("TochaMenu")
	get_node("Control/Tocha/Light2D/LuzPlayer").play("LuzMainMenu")

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		set_process_input(false)
		get_node("Control/Fade/FadePlayer").play("Fade")
		yield(get_tree().create_timer(1.2), "timeout")
		get_tree().change_scene("res://Fase 1.tscn")
		
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
