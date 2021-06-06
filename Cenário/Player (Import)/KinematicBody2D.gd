extends KinematicBody2D

var speed = 60
var tile_size = 16

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()


func _ready():
	target_position = position
	last_position = position

func _process(delta):
	#MOVENDO
	if $RayCast2D.is_colliding():
		#COLIDIU
		position = last_position
		target_position = position
	else:
		#MOVER-SE
		position += speed * direction * delta
		
		if position.distance_to(last_position) >= tile_size - speed * delta:
			position = target_position
	
	#PARADA
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size
	
	animar()

func set_direction():
	var UP = Input.is_action_pressed("up")
	var DOWN = Input.is_action_pressed("down")
	var LEFT = Input.is_action_pressed("left")
	var RIGHT = Input.is_action_pressed("right")

	direction.x = int(RIGHT) - int(LEFT)
	direction.y = int(DOWN) - int(UP)
	
	if direction.x != 0 && direction.y != 0:
		direction = Vector2(0,0)
	
	if direction != Vector2():
		$RayCast2D.cast_to = direction * tile_size


func animar():
	var anim_direc = "D"
	var anim_modo = "Par"
	var animation
	
	match get_node("RayCast2D").cast_to:
		Vector2(0,-16):
			anim_direc = "C"
		Vector2(0,16):
			anim_direc = "B"
		Vector2(-16,0):
			anim_direc = "E"
		Vector2(16,0):
			anim_direc = "D"
	
	if direction != Vector2(0,0):
		anim_modo = "And"
	else:
		anim_modo = "Par"
	animation = anim_modo + "_" + anim_direc
	get_node("AnimationPlayer").play(animation)

