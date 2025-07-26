extends Node2D

var _cherry_scene = preload("res://fruits/cherry.tscn")
var _grape_scene = preload("res://fruits/grape.tscn")
var _apple_scene = preload("res://fruits/apple.tscn")
var _pear_scene = preload("res://fruits/pear.tscn")
var _lemon_scene = preload("res://fruits/lemon.tscn")
var _orange_scene = preload("res://fruits/orange.tscn")
var _watermelon_scene = preload("res://fruits/watermelon.tscn")

var _current_fruit
var _fruit_list = [_cherry_scene, _grape_scene, _lemon_scene, _orange_scene, _apple_scene, _pear_scene, _watermelon_scene]

func _physics_process(delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()

func _spawn_fruit(pos, fruit_id):
	_current_fruit = _fruit_list[fruit_id].instantiate()
	add_child(_current_fruit)
	_current_fruit.fruits_collided.connect(_spawn_next_fruit)
	_current_fruit.position = pos

func _on_player_dropped_fruit(pos, fruit_id) -> void:
	$drop_sfx.play()
	_spawn_fruit(pos, fruit_id)
	
func _spawn_next_fruit(fruit_id, pos):
	var fruit_id_to_spawn = fruit_id + 1
	#print("Spawning fruit id:", fruit_id_to_spawn)
	if fruit_id_to_spawn < _fruit_list.size():
		_spawn_fruit(pos, fruit_id_to_spawn)
	#else:
		#print("Max fruit reached.")
