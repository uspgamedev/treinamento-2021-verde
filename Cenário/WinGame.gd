extends Control

func _ready():
	$Fade/AnimationPlayer.play("Fade_LW")
	$"Light2D/AnimationPlayer".play("Luz_YouLW")
	$"You Win/AnimationPlayer".play("Texto_YouWin")
	yield(get_node("Fade/AnimationPlayer"), "animation_finished")
	get_node("Fade").queue_free()
	
func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
