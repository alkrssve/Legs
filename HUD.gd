extends CanvasLayer

func _ready():
	load_hearts()
	load_coins()
	Global.hud = self


func load_hearts():
	$Life/HealthFull.rect_size.x = Global.lives * 17
	$Life/HealthEmpty.rect_size.x = (Global.max_lives - Global.lives) * 17
	$Life/HealthEmpty.rect_position.x = $Life/HealthFull.rect_position.x + $Life/HealthFull.rect_size.x * $Life/HealthFull.rect_scale.x

func load_coins():
	$Coins.text = String(Global.coins)



