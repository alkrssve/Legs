extends Sprite

func _ready():
	position.x = rand_range(-500,1000)
	position.y = rand_range(-500,500)

func _process(delta):
	if position.x > 1000:
		position.x = -400
	
