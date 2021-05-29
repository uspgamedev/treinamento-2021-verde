extends KinematicBody2D

var velocidade = Vector2(0,0)

onready var playeranimation = $AnimationPlayer
onready var treeanimation = $AnimationTree
onready var animation = treeanimation.get("parameters/playback")
var speed = 100
const acc = 500
const vmax = 120
const atrito = 800

func _physics_process(delta):
	
	var resultante = Vector2(0,0)
	
	resultante.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	resultante.y = Input.get_action_strength("baixo") - Input.get_action_strength("cima")
	resultante = resultante.normalized()
	if resultante != Vector2.ZERO:
		treeanimation.set("parameters/Andando/blend_position", resultante)
		treeanimation.set("parameters/Parado/blend_position", resultante)
		velocidade = velocidade.move_toward(resultante * vmax, acc * delta)
		animation.travel("Andando")
	else:
		
		velocidade = velocidade.move_toward(Vector2.ZERO, atrito * delta)
		animation.travel("Parado")
		
	move_and_slide(velocidade)
