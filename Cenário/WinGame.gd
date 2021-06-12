extends Control

func _ready():
	$Fade/AnimationPlayer.play("Fade_LW")
	$"Light2D/AnimationPlayer".play("Luz_YouLW")
	$"You Win/AnimationPlayer".play("Texto_YouWin")
	yield(get_tree().create_timer(1.2), "timeout")
	get_node("Fade").queue_free()
	
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
