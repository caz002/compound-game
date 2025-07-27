extends Node

var FAIL_TIME = 4
var fail_timer = 0
var score = 0

func add_to_fail_timer(delta):
	fail_timer += delta

func clear_fail_timer():
	fail_timer = 0

func add_score(points):
	score += points
	
func clear_score():
	score = 0
