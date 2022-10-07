extends KinematicBody2D

var MOVE_SPEED = 200
const JUMP_FORCE = 400
const GRAVITY = 35
const MAX_FALL_SPEED = 1000

var jump_max = 2
var jump_count = 0

var player_money = 0

var player_last_ground_position_x = 0
var player_last_ground_position_y = 0

onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite
onready var timer = $Timer

var y_velo = 0
var facing_right = false

var crouched = false

var townHall_hover = false
var shopKeeper_hover = false

func _ready():
	timer.set_wait_time(1)
	timer.start()

func _physics_process(delta):
	
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1))
	
	var grounded = is_on_floor()
	if grounded:
		jump_count = 0
	
	y_velo += GRAVITY
	
	if jump_count<jump_max:
		if Input.is_action_just_pressed("jump"):
			y_velo = -JUMP_FORCE
			jump_count += 1
			
	if grounded and y_velo >= 5:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
	if grounded and Input.is_action_pressed("crouch"):
		crouched = true
		MOVE_SPEED = 100
	if Input.is_action_just_released("crouch"):
		crouched = false
		MOVE_SPEED = 200
	
	if facing_right and move_dir > 0:
		flip()
	if !facing_right and move_dir < 0:
		flip()
	
	if grounded:
		if crouched:
			play_anim("Crouch")
		elif move_dir == 0 || is_on_wall():
			play_anim("Idle")
		else:
			play_anim("Move")
	else:
		play_anim("Jump")
		
	if townHall_hover and Input.is_action_pressed("enter"):
		get_tree().change_scene("res://TownHall.tscn")
		
	if shopKeeper_hover and Input.is_action_pressed("enter"):
		if (get_tree().get_current_scene().get_name() == "ShopKeepersHouse"):
			get_tree().change_scene("res://Town.tscn")
		else:
			get_tree().change_scene("res://ShopKeepersHouse.tscn")
			
	
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
		
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func _on_SaveStatue_area_entered(area):
	var saveStatue_anim_player = get_parent().get_node("SaveStatue/AnimationPlayer")
	saveStatue_anim_player.play("On")



func _on_SaveStatue_area_exited(area):
	var saveStatue_anim_player = get_parent().get_node("SaveStatue/AnimationPlayer")
	saveStatue_anim_player.play("Off")


func _on_coin_collected():
	player_money += 10

func _on_TownHall_player_enter():
	townHall_hover = true


func _on_TownHall_player_exit():
	townHall_hover = false
	

func _on_ShopKeepersHouse_player_enter():
	shopKeeper_hover = true


func _on_ShopKeepersHouse_player_exit():
	shopKeeper_hover = false


func _on_Fallout_area_entered(area):
	position.x = player_last_ground_position_x
	position.y = player_last_ground_position_y


func _on_Timer_timeout():
	if is_on_floor():
		player_last_ground_position_x = position.x
		player_last_ground_position_y = position.y
