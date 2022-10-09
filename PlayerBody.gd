extends KinematicBody2D

var MOVE_SPEED = 200
var BULLET_SPEED = 200
var FIRE_RATE = 0.5
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

var saveStatue_anim_player

var velocity = Vector2(0,0)
var y_velo = 0
var facing_right = false

var crouched = false

var townHall_hover = false
var shopKeeper_hover = false
var statue_hover = false

var can_fire = true

var save_finish = true

var bullet = preload("res://Bullet.tscn")


func _ready():
	Global.player = self
	load_position()
	timer.set_wait_time(1)
	timer.start()

func _physics_process(delta):
	
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
		velocity.x = -1
	move_and_slide(Vector2(velocity.x * MOVE_SPEED, y_velo), Vector2(0, -1))
	
	velocity.x = lerp(velocity.x,0,0.5)
	
	if can_fire and Input.is_action_pressed("shoot"):
		fire()
		can_fire = false
		yield(get_tree().create_timer(FIRE_RATE), "timeout")
		can_fire = true
	
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
		MOVE_SPEED = 50
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
		
	if townHall_hover and Input.is_action_pressed("interact"):
		Global.last_position(position.x,position.y,get_tree().get_current_scene().get_name())
		get_tree().change_scene("res://TownHall.tscn")
		
	if shopKeeper_hover and Input.is_action_pressed("interact"):
		if (get_tree().get_current_scene().get_name() == "ShopKeepersHouse"):
			get_tree().change_scene("res://Town.tscn")
		else:
			Global.position_lost = false
			Global.last_position(position.x,position.y,get_tree().get_current_scene().get_name())
			get_tree().change_scene("res://ShopKeepersHouse.tscn")
	
	if save_finish and statue_hover and Input.is_action_just_pressed("interact"):
		saveStatue_anim_player.play("Save")
		save_finish = false
		
		
func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position.x = position.x
	bullet_instance.position.y = position.y - 15
	get_parent().add_child(bullet_instance)
		
	
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h
		
func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)


func _on_SaveStatue_area_entered(area):
	saveStatue_anim_player = get_parent().get_node("SaveStatue/AnimationPlayer")
	saveStatue_anim_player.play("On")
	statue_hover = true



func _on_SaveStatue_area_exited(area):
	saveStatue_anim_player = get_parent().get_node("SaveStatue/AnimationPlayer")
	if save_finish:
		saveStatue_anim_player.play("Off")
	save_finish = true
	statue_hover = false


func player_coin_collected():
	Global.collect_money()

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
	Global.lose_life()
	if Global.lives == 0:
		get_tree().reload_current_scene()


func _on_Timer_timeout():
	if is_on_floor():
		player_last_ground_position_x = position.x
		player_last_ground_position_y = position.y
		


func _on_SaveStatue_saveFinished(Anim_Finished):
	save_finish = true

func damage(var enemyposx):
	Global.lose_life()
	set_modulate(Color(1,0.3,0.3,0.3))
	y_velo = JUMP_FORCE
	if position.x < enemyposx:
		velocity.x = -10
	elif position.x > enemyposx:
		velocity.x = 10
	
	Input.action_release("move_left")
	Input.action_release("move_right")
	
	$DamageTimer.start()
	
func _on_DamageTimer_timeout():
	set_modulate(Color(1,1,1,1))

func load_position():
	if !Global.position_lost && Global.scn == get_tree().get_current_scene().get_name():
		position.x = Global.last_x
		position.y = Global.last_y

