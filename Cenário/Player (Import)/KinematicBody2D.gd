extends KinematicBody2D

var speed = 50
var tile_size = 16

var direction = Vector2()
var last_position = Vector2()
var target_position = Vector2()

var n = 0
var m = 0

func _ready():
	$AnimationPlayer.play("And_D")
	$AnimationPlayer2.play("PlayerEntrada")
	
	#PAUSA DA ENTRADA
	yield(get_node("AnimationPlayer2"), "animation_finished")
	
	#SPAWNAR COLISÃO DA ENTRADA
	get_parent().get_node("ColisaoEntrada/CollisionShape2D").disabled = false
	
	#RESETAR VARIÁVEIS
	last_position = position
	target_position = position

func _process(delta):
	#PAUSA DA ENTRADA
	if n == 0:
		yield(get_node("AnimationPlayer2"), "animation_finished")
		n = 1
	
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
	
	#PARADO
	if position == target_position:
		set_direction()
		last_position = position
		target_position += direction * tile_size
	
	animar()

func set_direction():
	#PAUSA DA ENTRADA
	if m == 0:
		yield(get_tree().create_timer(0.1), "timeout")
		m = 1
		return
	
	#DETERMINAR DIREÇÃO	
	var UP = Input.is_action_pressed("up")
	var DOWN = Input.is_action_pressed("down")
	var LEFT = Input.is_action_pressed("left")
	var RIGHT = Input.is_action_pressed("right")

	direction.x = int(RIGHT) - int(LEFT)
	direction.y = int(DOWN) - int(UP)
	
	#IMPEDIR MOVIMENTO DIAGONAL
	if direction.x != 0 && direction.y != 0:
		direction = Vector2(0,0)
	
	#APONTAR RAYCAST
	if direction != Vector2():
		$RayCast2D.cast_to = direction * int(tile_size / 1.1)


func animar():
	var anim_direc = "D"
	var anim_modo = "Par"
	var animation
	
	match get_node("RayCast2D").cast_to:
		Vector2(0,-14):
			anim_direc = "C"
		Vector2(0,14):
			anim_direc = "B"
		Vector2(-14,0):
			anim_direc = "E"
		Vector2(14,0):
			anim_direc = "D"
	
	if direction != Vector2(0,0):
		anim_modo = "And"
	else:
		anim_modo = "Par"
		
	animation = anim_modo + "_" + anim_direc
	get_node("AnimationPlayer").play(animation)

