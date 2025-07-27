extends Area2D
@onready var fail_overlay: Panel = $Fail_Popup
@onready var fail_bar = $"../FailBar"

var fruits_inside = []

func _on_body_entered(body):
	if body is FruitBase:
		if body not in fruits_inside:
			fruits_inside.append(body)

func _on_body_exited(body):
	if body is FruitBase:
		fruits_inside.erase(body)

func _physics_process(delta):
	if fruits_inside.size() > 0:
		Globals.add_to_fail_timer(delta)
		if Globals.fail_timer >= Globals.FAIL_TIME:
			fail_game()
	else:
		Globals.clear_fail_timer()
			
func fail_game():
	#print("fail!")
	var fail_overlay = get_node("../Fail_Popup")
	if fail_overlay:
		fail_overlay.visible = true
	#var menu_button = get_node("../InGame_MainMenu")
	#if menu_button:
		#menu_button.visible = false
	#var score = get_node("../Score")
	#if score:
		#score.visible = false
	#var fail_bar = get_node("../FailBar")
	#if fail_bar:
		#fail_bar.visible = false
	Globals.FAIL = true
