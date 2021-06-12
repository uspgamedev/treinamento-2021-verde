extends Control

func _ready():
	$Fade/AnimationPlayer.play("Fade_LW")
	$"VBoxContainer/Bloco 1/Light2D/AnimationPlayer".play("Luz_YouLW")
	$"VBoxContainer/Bloco 1/You Lose/AnimationPlayer".play("Texto_YouLose")
	yield(get_tree().create_timer(1.2), "timeout")
	$"VBoxContainer/Bloco 1/Boo/AnimationPlayer".play("Boo")
	get_node("Fade").queue_free()

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	yield(get_tree().create_timer(10), "timeout")
	$"VBoxContainer/Bloco 1/Boo/AnimationPlayer".play("Boo")
