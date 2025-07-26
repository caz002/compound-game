extends Control

func _ready():
	pass
func _process(delta):
	pass


func _on_start_pressed():
	$Click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://game.tscn")


func _on_exit_pressed():
	$Click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
