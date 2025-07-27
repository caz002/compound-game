extends TextureRect

var start_y = 0
var time := 0.0

func _ready():
	start_y = position.y

func _process(delta):
	time += delta
	position.y = start_y + cos(time * 2.0) * 8
