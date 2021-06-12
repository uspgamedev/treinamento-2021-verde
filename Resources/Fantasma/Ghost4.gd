extends KinematicBody2D

var laststate = Vector2()
var state = Vector2()
var randomx
var randomy
onready var player = get_parent().get_node("Player")
var player_in_range = false
var player_in_sight
var path_pos = 0 # qual ponto do caminho ele vai seguir


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameter/playback")


onready var start_timer = get_node("Start_timer")
onready var timer = get_node("Path_timer")
onready var timer2 = get_node("Random_timer")

var random_timer_on = false
var path_timer_on = false

export(float) var SPEED = 20.0
enum STATES { IDLE, FOLLOW }
var _state = null

var path = []
var target_point_world = Vector2()
var target_position = Vector2()

var velocity = Vector2()

func _ready():
	start_timer.set_wait_time(7)
	timer.set_wait_time(15)
	timer2.set_wait_time(30)
	start_timer.start()
	_change_state(STATES.IDLE)


func _change_state(new_state):
	if new_state == STATES.FOLLOW:
		#print("entrou")
		path = get_parent().get_node("Obs").find_path(position, target_position)
		#print("posição é:" , target_position)
		if not path or len(path) == 1:
			#print(target_position, " não é caminho")
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
			#print("chegou") # Aqui ele marca quando chegou

			_change_state(STATES.IDLE)
			return
		target_point_world = path[0]

func move_to(world_position):
	var MASS = 1.0 #10
	var ARRIVE_DISTANCE = 10.0 # 10

	animate(position.direction_to(world_position).normalized())
	var desired_velocity = (world_position - position).normalized() * SPEED
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()

	#print(get_angle_to(position)/3.14 * 180)


	return position.distance_to(world_position) < ARRIVE_DISTANCE


func animate(direction):
	if direction != Vector2.ZERO:
		animationTree.set("parameters/a/blend_position", direction)
		animationTree.set("parameters/Walking/blend_position", direction)
		pass
	else: #????????? ta funcionando mas não do jeito que devia
		animationState.travel("Idle")
	

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

func get_pos_player(player):
	target_position.x = int(player.global_position.x /3)
	target_position.y = int(player.global_position.y /3)
	_change_state(STATES.FOLLOW)

func move_decision():
	if player_in_range == true:
		get_pos_player(player)
	else:
		if random_timer_on:
			#print("Passou caminho")
			get_patrol_path()
		if path_timer_on:
			#print("Passou aleatorio")
			get_random_pos()
			
			
func get_patrol_path():
	if path_pos == 3:
		path_pos = 0
	var pos1 = get_parent().get_node("Posicoes4").get_child(path_pos)
	target_position = pos1.global_position / 3
	#print(pos1.name)
	path_pos += 1
	_change_state(STATES.FOLLOW)	

func get_random_pos():

	randomx = (rand_range(97/3,1329/3))
	randomy = (rand_range(97/3,879/3))
	target_position.x = randomx
	target_position.y = randomy
	#print(target_position)
	_change_state(STATES.FOLLOW)
	

func _on_Area2D_body_entered(body):
	if body == player:
		player_in_range = true




func _on_Area2D_body_exited(body):
	if body == player:
		player_in_range = false
		#print("Player no range ", player_in_range)


func _on_Area2D2_body_entered(body):
	if body == player:
		player_in_range = true

func _on_Area2D2_body_exited(body):
	if body == player:
		player_in_range = false
		#print("Player no range ", player_in_range)


func _on_Timer_timeout(): # Posição aleatoria
#	random_timer_on = false
#	path_timer_on = true
	activate_timer(2)
	#print("Acabou o tempo no Timer?")

	
func _on_Path_timer_timeout():
	activate_timer(1)
	#print("Acabou o tempo no Timer?")



func _on_Start_timer_timeout():
	activate_timer(0)
