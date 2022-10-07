extends Area2D

signal player_enter
signal player_exit

func _on_Entrance_area_entered(area):
	emit_signal("player_enter")


func _on_Entrance_area_exited(area):
	emit_signal("player_exit")
