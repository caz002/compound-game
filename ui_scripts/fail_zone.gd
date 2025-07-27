extends Area2D

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
	Globals.FAIL = true
