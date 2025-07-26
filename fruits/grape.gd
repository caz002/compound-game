extends FruitBase

func _ready():
	_init()
	fruit_id = SUIKA.FRUITS.GRAPE
	await get_tree().create_timer(0.2).timeout
	_active = true
