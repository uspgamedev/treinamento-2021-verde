extends Control

func _ready():
	$"VBoxContainer/Bloco 1/Boo/AnimationPlayer".play("Boo")
	$Fade/AnimationPlayer.play("Fade_LW")
	$"VBoxContainer/Bloco 1/Light2D/AnimationPlayer".play("Luz_YouLW")
	$"VBoxContainer/Bloco 1/You Lose/AnimationPlayer".play("Texto_YouLose")
	yield(get_node("Fade/AnimationPlayer"), "animation_finished")
	$"VBoxContainer/Bloco 1/Boo/AnimationPlayer".play("Boo")
	get_node("Fade").queue_free()

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
