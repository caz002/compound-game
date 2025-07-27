extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("close"):
		get_tree().quit()

func _spawn_fruit(pos, fruit_id):
	Globals._current_fruit = Globals._fruit_list[fruit_id].instantiate()
	Globals._current_fruit.add_to_group("orbs")
	add_child(Globals._current_fruit)
	Globals._current_fruit.fruits_collided.connect(_spawn_next_fruit)
	Globals._current_fruit.earth_water_combo.connect(_grow_two_orbs)
	Globals._current_fruit.earth_fire_combo.connect(_shrink_three_orbs)
	Globals._current_fruit.water_fire_combo.connect(_toss_all_orbs_upwards)
	Globals._current_fruit.position = pos

func _on_player_dropped_fruit(pos, fruit_id) -> void:
	$drop_sfx.play()
	_spawn_fruit(pos, fruit_id)
	
func _spawn_next_fruit(fruit_id, pos):
	var fruit_id_to_spawn = fruit_id + 1
	if fruit_id_to_spawn < Globals._fruit_list.size():
		_spawn_fruit(pos, fruit_id_to_spawn)


func _grow_two_orbs():
	var orbs_in_group = get_tree().get_nodes_in_group("orbs").duplicate()
	orbs_in_group.shuffle()

	var num_to_grow = mini(2, orbs_in_group.size())

	var grown_count = 0
	for orb in orbs_in_group:
		if grown_count >= num_to_grow:
			break

		if not is_instance_valid(orb):
			continue

		var current_pos = orb.position
		var new_fruit_id = orb.fruit_id + 1
	
		var points = pow(2, orb.fruit_id + 1) * 10
		Globals.add_score(points)
	
		if new_fruit_id < Globals._fruit_list.size():
			_spawn_fruit(current_pos, new_fruit_id)
			orb.queue_free()
			grown_count += 1

func _shrink_three_orbs():
	var orbs_in_group = get_tree().get_nodes_in_group("orbs").duplicate()
	orbs_in_group.shuffle()

	var num_to_shrink = mini(3, orbs_in_group.size())

	var shrink_count = 0
	for orb in orbs_in_group:
		if shrink_count >= num_to_shrink:
			break

		if not is_instance_valid(orb):
			continue

		var current_pos = orb.position
		var new_fruit_id = orb.fruit_id - 1
	
		if new_fruit_id >= 0:
			_spawn_fruit(current_pos, new_fruit_id)
			orb.queue_free()
			shrink_count += 1

func _toss_all_orbs_upwards(toss_strength_min: float = 100.0, toss_strength_max: float = 100.0, horizontal_randomness: float = 50.0):

	var orbs_to_toss = get_tree().get_nodes_in_group("orbs").duplicate()

	for orb in orbs_to_toss:
		if not is_instance_valid(orb):
			continue

		var upward_force = randf_range(toss_strength_min, toss_strength_max)

		var horizontal_force = randf_range(-horizontal_randomness, horizontal_randomness)

		var toss_vector = Vector2(horizontal_force, -upward_force)

		orb.apply_central_impulse(toss_vector)
		orb.angular_velocity += randf_range(-10.0, 10.0)
