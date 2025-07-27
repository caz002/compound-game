extends Node2D
@onready var fail_overlay: Panel = $Fail_Popup
@onready var main_menu_button = $Fail_Popup/Main_Menu_Button
@onready var in_game_main_menu = $InGame_MainMenu
@onready var fail_bar = $FailBar

@export var tween_intensity: float
@export var tween_duration: float

func _ready():
	fail_overlay.visible = false
	in_game_main_menu.visible = true
	fail_bar.visible = true
	
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

	var num_to_shrink = mini(2, orbs_in_group.size())

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

func _toss_all_orbs_upwards(toss_strength_min: float = 100.0, toss_strength_max: float = 50.0, horizontal_randomness: float = 25.0):

	var orbs_to_toss = get_tree().get_nodes_in_group("orbs").duplicate()

	for orb in orbs_to_toss:
		if not is_instance_valid(orb):
			continue

		var upward_force = randf_range(toss_strength_min, toss_strength_max)

		var horizontal_force = randf_range(-horizontal_randomness, horizontal_randomness)

		var toss_vector = Vector2(horizontal_force, -upward_force)

		orb.apply_central_impulse(toss_vector)
		orb.angular_velocity += randf_range(-10.0, 10.0)

# Functions for End game overlay
func _on_main_menu_button_pressed():
	$Click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://ui_scenes/main_menu.tscn")
	Globals.score = 0

func _on_in_game_main_menu_pressed():
	$Click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://ui_scenes/main_menu.tscn")
	Globals.score = 0

func _process(delta:float) -> void:
	if is_instance_valid(main_menu_button) and main_menu_button.visible:
		btn_hovered(main_menu_button)
	btn_hovered(in_game_main_menu)
func start_tween(object: Object, property: String, final_val : Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size/2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)
