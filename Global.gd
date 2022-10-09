extends Node

var max_lives = 3
var lives = max_lives
var coins = 0
var last_x = 0
var last_y = 0
var position_lost = false
var scn 
var hud
var player

func lose_life():
	lives -= 1
	hud.load_hearts()
	if lives <= 0:
		position_lost = true
		get_tree().change_scene("res://Town.tscn")
		lives = 3

func collect_money():
	coins += 10
	hud.load_coins()

func last_position(lstx,lsty,lstscn):
	last_x = lstx
	last_y = lsty
	scn = lstscn
	player.load_position()
	
