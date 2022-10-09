extends Area2D

signal coin_collected

func _on_Coin_body_entered(body):
	emit_signal("coin_collected")
	$AnimationPlayer.play("Collect")
	



func _on_AnimationPlayer_animation_finished(anim_name = "Collect"):
	queue_free()
