extends Area2D

var speed = 5
var movement = Vector2()
onready var mouse_pos = null

func _ready():
	mouse_pos = get_local_mouse_position()

func _physics_process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - position).normalized()
	var new_angle = PI + atan2(direction.y, direction.x)
	rotation = new_angle
	movement = movement.move_toward(mouse_pos, delta)
	movement = movement.normalized() * speed
	position = position + movement


func _on_Area2D_body_entered(body):
	if !body.is_in_group("Player"):
		queue_free()
