extends KinematicBody2D



var randomx # Variaveis de posição aleatoria
var randomy	#

onready var player = get_parent().get_node("Player")

var player_in_range = false # verifica se o player está no range para ativar o chase

var path_pos = 0 # qual ponto do caminho ele vai seguir

# Toca a animação
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameter/playback")

# Timers
onready var start_timer = get_node("Start_timer") # Timer para ficar parado no inicio
onready var timer = get_node("Path_timer") # Tempo que fica fazendo patrulha
onready var timer2 = get_node("Random_timer") # Tempo que anda aleatoriamente

# Variaveis que definem qual timer ativar

var random_timer_on = false 
var path_timer_on = false

export(float) var SPEED = 20.0

# Estado que o progama tem que rodar 
enum STATES { IDLE, FOLLOW }

# Estado inicial do programa
var _state = null

# Vetor de pontos do caminho escolhido
var path = []

# Caminho alvo na cena
var target_point_world = Vector2()

# Posição alvo
var target_position = Vector2()

# 
var velocity = Vector2()


############## Principais ################

func _ready():
	# Define os timers
	start_timer.set_wait_time(1)
	timer.set_wait_time(30)
	timer2.set_wait_time(15)
	start_timer.start()
	_change_state(STATES.IDLE)

# Muda o modo de execução do programa caso esteja parado

func _change_state(new_state):

	if new_state == STATES.FOLLOW:

		path = get_parent().get_node("TileMap").find_path(position, target_position)

		if not path or len(path) == 1:

			_change_state(STATES.IDLE)
			return
		target_point_world = path[1]
	_state = new_state


func _process(delta):

	if not _state == STATES.FOLLOW:
		move_decision()
		return
	if player_in_range:
		move_decision()
	var arrived_to_next_point = move_to(target_point_world)
	if arrived_to_next_point:
		path.remove(0)
		if len(path) == 0:
			_change_state(STATES.IDLE)
			return
		target_point_world = path[0]


############## Comandos de decisão de movimento ################

func get_pos_player(player):
	target_position.x = int(player.global_position.x /3)
	target_position.y = int(player.global_position.y /3)
	_change_state(STATES.FOLLOW)

func move_decision():
	if player_in_range == true:
		get_pos_player(player)
	else:
		if random_timer_on:
			get_patrol_path()
		if path_timer_on:
			get_random_pos()

func get_patrol_path():
	if path_pos == 3:
		path_pos = 0
	var pos1 = get_parent().get_node("Posicoes2").get_child(path_pos)
	target_position = pos1.global_position / 3
	path_pos += 1
	_change_state(STATES.FOLLOW)	

func get_random_pos():

	randomx = (rand_range(175,320))
	randomy = (rand_range(32,128))
	target_position.x = randomx
	target_position.y = randomy
	_change_state(STATES.FOLLOW)

############## Comandos movimento ################

# Esta função move o inimigo para o caminho selecionado
func move_to(world_position):
	var MASS = 1.0 #10
	var ARRIVE_DISTANCE = 10.0 # 10

	animate(position.direction_to(world_position).normalized())
	var desired_velocity = (world_position - position).normalized() * SPEED
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()

	return position.distance_to(world_position) < ARRIVE_DISTANCE

# Pega a animação correspondente a direção 
func animate(direction):
	if direction != Vector2.ZERO:
		animationTree.set("parameters/a/blend_position", direction)
		animationTree.set("parameters/Walking/blend_position", direction)
		pass
	else:
		animationState.travel("Idle")

############## Comandos de "Visão" do inimigo ################

# Detecção da "visão" horizontal
func _on_Area2D_body_entered(body):
	if body == player:
		player_in_range = true

func _on_Area2D_body_exited(body):
	if body == player:
		player_in_range = false
		#print("Player no range ", player_in_range)
# # # # # #

# Detecção da "visão" vertical
func _on_Area2D2_body_entered(body):
	if body == player:
		player_in_range = true

func _on_Area2D2_body_exited(body):
	if body == player:
		player_in_range = false
# # # # # #

############## Comandos de Temporizadores ################

# Função responsável pelo controle dos temporizadores

func activate_timer(mode):
	if mode == 0:
		start_timer.stop()
		random_timer_on = true
		timer.start()
	elif mode == 1:
		timer.stop()
		timer2.start()
	else:
		timer2.stop()
		timer.start()
	random_timer_on = not random_timer_on
	path_timer_on = not path_timer_on
	_change_state(STATES.FOLLOW)
	

# Função ativada quando o timer aleatorio vai a zero
func _on_Timer_timeout(): # Posição aleatoria
	activate_timer(2)


# Função ativada quando o timer de patrulha vai a zero
func _on_Path_timer_timeout():
	activate_timer(1)


# Função ativada quando o timer de inicio vai a zero, só ativa uma vez
func _on_Start_timer_timeout():
	activate_timer(0)

func _input(event):
	if event.is_action_pressed('click'):
		if Input.is_key_pressed(KEY_SHIFT):
			global_position = get_global_mouse_position() / 3
		else:
			target_position = get_global_mouse_position() / 3
			print(target_position)
