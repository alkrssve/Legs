extends KinematicBody2D

export var speed_modifier = 1
export var reverse = true
export var vertical = true

var start_position_x = position.x
var start_position_y = position.y

var direction_check = false

func _ready():
	start_position_x = self.get_position().x
	start_position_y = self.get_position().y
	if reverse:
		direction_check = true

func _physics_process(delta):
	if vertical == true:
		if (position.y > start_position_y + 50):
			direction_check = false
		if (position.y < start_position_y - 50):
			direction_check = true
	else:
		if (position.x > start_position_x + 50):
			direction_check = false
		if (position.x < start_position_x - 50):
			direction_check = true
	if direction_check:
		if vertical == true:
			position.y += speed_modifier
		else:
			position.x += speed_modifier
	else:
		if vertical == true:
			position.y -= speed_modifier
		else: 
			position.x -= speed_modifier
