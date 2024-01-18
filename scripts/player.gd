extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var canvas_layer = $CanvasLayer
@onready var shoot_particles = preload("res://scenes/shoot_particles.tscn")
@onready var coin_shot = preload("res://scenes/coin_shot.tscn")
@onready var gunshot_sound = $flintlock_audio
@onready var cannon_sound = $cannon_audio
@onready var shots = $shot_container

@export var coin_count = 0
@export var acceleration = 2000
@export var max_speed = 500
@export var jump_height = 600
@export var gravity_strength = 980
@export var friction = 1500
var alive = true
var attackShoot = false
var attackMelee = false
var facing = 0
var currently_facing = 1
var shot_type = "blunderbuss"

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity_strength * delta
		if velocity.y > 1000:
			velocity.y = 1000
	if Input.is_action_just_pressed("jump") && is_on_floor()==true && alive:
		jump(jump_height)
	if Input.is_action_just_pressed("move_down") && is_on_floor()==false:
		velocity.y += 500
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("melee"):
		melee()
	idle()
	
	if alive:
		facing = Input.get_axis("move_left","move_right")
	if facing != 0:
		animated_sprite.flip_h = (facing == -1)
		currently_facing = facing
		velocity.x += facing * acceleration * delta
	else:
		if velocity.x > 0:
			velocity.x -= friction * delta
			if velocity.x < 0:
				velocity.x = 0
		elif velocity.x < 0:
			velocity.x += friction * delta
			if velocity.x > 0:
				velocity.x = 0
		
	if velocity.x > max_speed:
		velocity.x = max_speed
	elif velocity.x < -max_speed:
		velocity.x = -max_speed
	flip()
	
	move_and_slide()

func jump(jump_height):
	velocity.y = -jump_height

func idle():
	if alive && !attackMelee && !attackShoot:
		if is_on_floor():
			if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		else:
			animated_sprite.play("jump")

func melee():
	if alive && !attackShoot:
		attackMelee = true
		if is_on_floor():
			if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				animated_sprite.play("run_melee")
			else:
				animated_sprite.play("melee")
		else:
			animated_sprite.play("jump_melee")
		await get_tree().create_timer(0.3).timeout
		attackMelee = false
		
func shoot():
	if alive && !attackMelee:
		attackShoot = true
		if is_on_floor():
			if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				animated_sprite.play("run_n_gun")
			else:
				animated_sprite.play("gun")
		else:
			animated_sprite.play("jump_gun")
			
		var shot = shoot_particles.instantiate()
		canvas_layer.add_child(shot)
		await get_tree().create_timer(0.216).timeout
		shot.emitting = true
		if shot_type == "flintlock":
			gunshot_sound.play()
			var gunshot = coin_shot.instantiate()
			shots.add_child(gunshot)
			gunshot.send_facing(currently_facing)
			gunshot.global_position = global_position
			gunshot.global_position.x += 35 * currently_facing
			gunshot.global_position.y += 8
		elif shot_type == "blunderbuss":
			#I will come back and make this code dry, I will do it, yes I will
			gunshot_sound.play()
			var gunshot = coin_shot.instantiate()
			var gunshot2 = coin_shot.instantiate()
			var gunshot3 = coin_shot.instantiate()
			var gunshot4 = coin_shot.instantiate()
			var gunshot5 = coin_shot.instantiate()
			add_child(gunshot)
			add_child(gunshot2)
			add_child(gunshot3)
			add_child(gunshot4)
			add_child(gunshot5)
			gunshot.send_facing(currently_facing)
			gunshot2.send_facing(currently_facing)
			gunshot3.send_facing(currently_facing)
			gunshot4.send_facing(currently_facing)
			gunshot5.send_facing(currently_facing)
			gunshot.global_position = global_position
			gunshot2.global_position = global_position
			gunshot3.global_position = global_position
			gunshot4.global_position = global_position
			gunshot5.global_position = global_position
			gunshot.global_position.x += 35 * currently_facing
			gunshot.global_position.y += 8
			gunshot2.global_position.x += 35 * currently_facing
			gunshot2.global_position.y += 8
			gunshot3.global_position.x += 35 * currently_facing
			gunshot3.global_position.y += 8
			gunshot4.global_position.x += 35 * currently_facing
			gunshot4.global_position.y += 8
			gunshot5.global_position.x += 35 * currently_facing
			gunshot5.global_position.y += 8
			gunshot2.set_change_y(2)
			gunshot3.set_change_y(4)
			gunshot4.set_change_y(-4)
			gunshot5.set_change_y(-2)
		await get_tree().create_timer(.5).timeout
		shot.emitting = false
		shot.queue_free()
		attackShoot = false
		
func flip():
	if currently_facing == 1:
		canvas_layer.rotation = 0
	else:
		canvas_layer.rotation = 3.14
	
func die():
	alive = false
	animated_sprite.play("die")
	await get_tree().create_timer(2).timeout
	velocity = Vector2.ZERO
	global_position = Vector2(178, 390)
	alive = true

func respawn():
	alive = true
