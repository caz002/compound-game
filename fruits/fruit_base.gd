extends RigidBody2D
class_name FruitBase

signal fruits_collided(fruit_id: int, spawn_position: Vector2)

@export var fruit_id = SUIKA.FRUITS
var _active = false
var _merged = false

@onready var collider = $CollisionShape2D

func _init():
	max_contacts_reported = 5
	contact_monitor = true
	_active = false

func _ready():
	# Activate fruit after short delay to prevent instant merging
	await get_tree().create_timer(0.2).timeout
	_active = true

func _physics_process(_delta: float) -> void:
	if !_active or _merged:
		return

	var contacts = get_colliding_bodies()
	for body in contacts:
		if body is FruitBase and fruit_id == body.fruit_id:
			# Only allow the fruit with the smaller instance_id to trigger merge
			if get_instance_id() < body.get_instance_id():
				merge_with(body)
			return

func merge_with(other: FruitBase):
	if _merged or other._merged:
		return

	# Mark both as merged
	_merged = true
	other._merged = true

	# Disable physics + collisions
	disable_fruit()
	other.disable_fruit()

	# Emit signal to create new fruit
	fruits_collided.emit(fruit_id, global_position)
	
	# Emit signal to add to score
	var points = pow(2, fruit_id + 1) * 10
	ScoreManager.add_score(points)

	# Defer deletion
	call_deferred("queue_free")
	other.call_deferred("queue_free")

func disable_fruit():
	freeze = true
	lock_rotation = true
	if collider:
		collider.disabled = true
	visible = false
