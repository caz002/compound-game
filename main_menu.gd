extends Control

@export var tween_intensity: float
@export var tween_duration: float

@onready var start: Button = $VBoxContainer/Start_Game
@onready var instructions: Button = $VBoxContainer/Instructions
@onready var exit: Button = $VBoxContainer/Exit

func _ready():
	pass
func _process(delta:float) -> void:
	btn_hovered(start)
	btn_hovered(instructions)
	btn_hovered(exit)

func _on_start_pressed():
	$Click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://game.tscn")


func _on_exit_pressed():
	$Click.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func start_tween(object: Object, property: String, final_val : Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size/2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)
