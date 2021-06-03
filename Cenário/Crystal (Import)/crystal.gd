extends Sprite


func _ready():
	$AnimationPlayer.play('crystal')

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		get_parent().score += 1
		queue_free()
	
