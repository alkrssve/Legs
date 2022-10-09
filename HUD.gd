extends CanvasLayer

var coins = 0

func _ready():
	$Coins.text = String(coins)



func _on_coin_collected():
	coins += 10
	_ready()


