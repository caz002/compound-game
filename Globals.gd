extends Node

var _cherry_scene = preload("res://orb_scenes/white.tscn")
var _grape_scene = preload("res://orb_scenes/earth.tscn")
var _lemon_scene = preload("res://orb_scenes/black.tscn")
var _orange_scene = preload("res://orb_scenes/fire.tscn")
var _apple_scene = preload("res://orb_scenes/water.tscn")
var _pear_scene = preload("res://orb_scenes/stone.tscn")
var _watermelon_scene = preload("res://orb_scenes/duck.tscn")

var _current_fruit

# cherry = white
# grape = earth
# lemon = black
# orange = fire
# apple = water
# pear = stone
# watermelon = duck
var _fruit_list = [_cherry_scene, _grape_scene, _lemon_scene, _orange_scene, _apple_scene, _pear_scene, _watermelon_scene]

enum FRUITS {CHERRY, GRAPE, LEMON, ORANGE, APPLE, PEAR, WATERMELON}

var FAIL_TIME = 4
var fail_timer = 0
var FAIL = false
var score = 0

func add_to_fail_timer(delta):
	fail_timer += delta

func clear_fail_timer():
	fail_timer = 0

func add_score(points):
	score += points
	
func clear_score():
	score = 0
