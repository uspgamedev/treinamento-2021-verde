extends KinematicBody2D

var direction = Vector2()
var speed = 0
var velocity = 0

const TOP = Vector2(0, -1)
const RIGHT = Vector2(1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)

func _physics_process(delta):

	var is_moving = Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right")
	
	if is_moving:
		speed = 125
		 
		if Input.is_action_pressed("up"):
			direction = TOP
		if Input.is_action_pressed("down"):
			direction = DOWN
		if Input.is_action_pressed("left"):
			direction = LEFT
		if Input.is_action_pressed("right"):
			direction = RIGHT
	else:
		speed = 0
	
	velocity = speed * direction * delta 
	move_and_collide(velocity)		
	
	animar()

func animar():
	var anim_direc = "D"
	var anim_modo = "Par"
	var animation
	
	match direction:
		TOP:
			anim_direc = "C"
		DOWN:
			anim_direc = "B"
		LEFT:
			anim_direc = "E"
		RIGHT:
			anim_direc = "D"
	
	if speed != 0:
		anim_modo = "And"
	else:
		anim_modo = "Par"
	animation = anim_modo + "_" + anim_direc
	get_node("AnimationPlayer").play(animation)

