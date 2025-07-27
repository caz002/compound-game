extends RigidBody2D
class_name FruitBase

signal fruits_collided(fruit_id: int, spawn_position: Vector2)
signal fruit_destroyed()

signal earth_fire_combo()
signal earth_water_combo()
signal water_fire_combo()

@export var fruit_id = Globals.FRUITS
var _active = false
var _merged = false

@onready var collider = $CollisionShape2D

func _init():
	max_contacts_reported = 5
	contact_monitor = true
	_active = false

func _ready():
	await get_tree().create_timer(0.2).timeout
	_active = true


func _physics_process(_delta: float) -> void:
	if !_active or _merged:
		return

	var contacts = get_colliding_bodies()
	for body in contacts:
		if body is FruitBase:

			if get_instance_id() < body.get_instance_id():
				
				if fruit_id == body.fruit_id:
					merge_with(body)
					return
				
				if is_pair(fruit_id, body.fruit_id, Globals.FRUITS.GRAPE, Globals.FRUITS.ORANGE):
					earth_fire_combo.emit()
					return
				if is_pair(fruit_id, body.fruit_id, Globals.FRUITS.GRAPE, Globals.FRUITS.APPLE):
					earth_water_combo.emit()
					return
				if is_pair(fruit_id, body.fruit_id, Globals.FRUITS.APPLE, Globals.FRUITS.ORANGE):
					water_fire_combo.emit()
					return
				

### helpers

func is_pair(a, b, x, y):
	return (a == x and b == y) or (a == y and b == x)
	
func merge_with(other: FruitBase):
	if _merged or other._merged:
		return

	_merged = true
	other._merged = true

	disable_fruit()
	other.disable_fruit()

	fruits_collided.emit(fruit_id, global_position)
	
	var points = pow(2, fruit_id + 1) * 10
	Globals.add_score(points)

	fruit_destroyed.emit()

	remove_from_group("orbs")
	other.remove_from_group("orbs")
	call_deferred("queue_free")
	other.call_deferred("queue_free")

func disable_fruit():
	freeze = true
	lock_rotation = true
	if collider:
		collider.disabled = true
	visible = false
