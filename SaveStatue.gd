extends Area2D

signal saveFinished(Anim_Finished)

var anim_Finished = false

func _ready():
	emit_signal("saveFinished(true)")


func _on_AnimationPlayer_animation_finished(anim_name = "Save"):
	anim_Finished = true
