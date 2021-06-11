extends Sprite

var matrix = [[32, 28], [48, 44], [64,28], [80, 28], [48, 60], [176,44], [128,92], [48,76], [176,28], [112,28]]
# matrix Axy = [0][0] = 32
# matrix Axy = [0][1] = 32

# matrix Axy = [1][0] = 48
# matrix Axy = [1][1] = 32

# matrix Axy = [2][0] = 48
# matrix Axy = [2][1] = 48

# matrix Axy = [3][0] = 64
# matrix Axy = [3][1] = 32

# matrix Axy = [4][0] = 80
# matrix Axy = [4][1] = 32

# matrix Axy = [5][0] = 48
# matrix Axy = [5][1] = 60


#  x   y
#  32 32
#  48 32
#  48 48
#  64 32


func _ready():
	randomize()
	$AnimationPlayer.play('crystal')
	var x_rand = (randi() % 10)
	var rnd_position = Vector2(matrix[x_rand][0], matrix[x_rand][1])
	print (x_rand)
	$".".position = rnd_position
	
	

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		get_parent().score += 1
		queue_free()
	
