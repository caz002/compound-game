extends CharacterBody2D

const PLAYER_SPEED = 4
const DROP_COOLDOWN= 50
var _tick = 0
var _waiting_to_spawn = false

@onready var _cherry_img = $Cherry
@onready var _grape_img = $Grape
@onready var _lemon_img = $Lemon
# make sure to add to node's children if you want to use these below 
#@onready var _orange_img = $Orange
#@onready var _apple_img = $Apple
#@onready var _pear_img = $Pear
#@onready var _watermelon_img = $Watermelon

@onready var _rng = RandomNumberGenerator.new()

signal dropped_fruit

var _fruit_list
var _current_fruit
var _current_fruit_id

func _pick_random_fruit():
	var rand = _rng.randf()
	if rand < 0.5:
		return 0
	elif rand < 0.8:
		return 1
	else:
		return 2

func _set_up_list():
	_fruit_list = [
		_cherry_img,
		_grape_img,
		_lemon_img
	]

func _ready():
	_set_up_list()
	_spawn_new_fruit()

func _physics_process(delta: float) -> void:
	
	if Globals.FAIL:
		_current_fruit.hide()
		return
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	move_and_collide(direction * PLAYER_SPEED)
	
	if Input.is_action_just_pressed("drop"):
		if !_waiting_to_spawn:
			_drop()
	if _waiting_to_spawn:
		_ticker()

func _spawn_new_fruit():
	_current_fruit_id = _pick_random_fruit()
	_current_fruit = _fruit_list[_current_fruit_id]
	_current_fruit.show()

func _drop():
	_current_fruit.hide()
	
	_waiting_to_spawn = true
	dropped_fruit.emit(position, _current_fruit_id)

func _ticker():
	_tick += 1
	if _tick > DROP_COOLDOWN:
		_tick = 0
		_spawn_new_fruit();
		_waiting_to_spawn = false
		
