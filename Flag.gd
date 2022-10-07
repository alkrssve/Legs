extends Sprite

onready var anim_player = $AnimationPlayer

func _ready():
	play_anim("Flag_Waving")

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)
