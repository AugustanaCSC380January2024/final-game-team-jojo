extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var canvas_layer = $CanvasLayer
@onready var shoot_particles = preload("res://scenes/shoot_particles.tscn")
@onready var coin_shot = preload("res://scenes/coin_shot.tscn")
@onready var coin_cannon_shot = preload("res://scenes/coin_cannonball.tscn")
@onready var melee_hitbox = preload("res://scenes/player_melee_hitbox.tscn")
@onready var gunshot_sound = $flintlock_audio
@onready var cannon_sound = $cannon_audio
@onready var shots = $shot_container
@onready var hud = $HUD
@onready var camera = $Camera2D

@export var hurt_i_frames = 0
@export var max_lives = 3
@export var lives = 3
@export var coin_count = 5
@export var acceleration = 2000
@export var original_jump_height = 600
@export var original_max_speed = 500
@export var max_speed = 500
@export var jump_height = 600
@export var max_fall_speed = 2000
@export var gravity_strength = 980
@export var friction = 2500
@export var attack_timer = 0
@export var melee_attack_timer = 0
var coyote_time = 0.0
var jump_buffer = 0.0
var alive = true
var attackShoot = false
var attackMelee = false
var facing = 0
var currently_facing = 1
var shot_type = "blunderbuss"
var cameraCounterX = 0
var cameraCounterY = 0
var idleTime = 0


func _ready():
	set_floor_max_angle(PI/3)
	hud.set_coin_counter(coin_count)

func _physics_process(delta):
	#if(is_on_floor()):
		#print("Floor")
	#if(is_on_wall()):
		#print("Wall")
	#if(is_on_ceiling()):
		#print("Ceiling")
	if attack_timer >= 0:
		attack_timer -= delta
	if melee_attack_timer >= 0:
		melee_attack_timer -= delta
	changeCamera()
	if hurt_i_frames > 0:
		hurt_i_frames -= delta
		#print(hurt_i_frames)
	coyote_time -= delta
	jump_buffer -= delta
	if !is_on_floor():
		if velocity.y > 0:
			velocity.y += 8
		velocity.y += gravity_strength * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	else:
		coyote_time = 0.1
	if Input.is_action_just_pressed("jump") && alive:
		if(is_on_floor() || coyote_time > 0):
			jump(jump_height)
			jump_buffer = 0.0
			coyote_time = 0.0
		else:
			jump_buffer = 0.1
	if Input.is_action_just_pressed("move_down") && is_on_floor()==false:
		velocity.y += 500
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("melee"):
		melee()
	if Input.is_action_just_pressed("select_flintlock"):
		shot_type = "flintlock"
	if Input.is_action_just_pressed("select_blunderbuss"):
		shot_type = "blunderbuss"
	if Input.is_action_just_pressed("select_cannon"):
		shot_type = "cannon"
	idle()
	
	if alive:
		facing = Input.get_axis("move_left","move_right")
	if facing != 0 and alive:
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
	GlobalValues.playerPosition = global_position
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
	if alive && !attackShoot && melee_attack_timer <= 0:
		melee_attack_timer = .7
		attackMelee = true
		if is_on_floor():
			if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				animated_sprite.play("run_melee")
			else:
				animated_sprite.play("melee")
		else:
			animated_sprite.play("jump_melee")
		await get_tree().create_timer(0.1).timeout
		var attack_hitbox = melee_hitbox.instantiate()
		add_child(attack_hitbox)
		await get_tree().create_timer(0.3).timeout
		attack_hitbox.queue_free()
		attackMelee = false
		
		
func shoot():
	if alive && !attackMelee && attack_timer <= 0:
		if (shot_type == "flintlock" && coin_count >= 1) || (shot_type == "blunderbuss" && coin_count >= 2) || (shot_type == "cannon" && coin_count >= 3): #add no ammo indicator
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
			attack_timer = 1
			await get_tree().create_timer(0.216).timeout
			shot.emitting = true
			if shot_type == "flintlock":
				coin_count -= 1
				hud.set_coin_counter(coin_count)
				gunshot_sound.play()
				var gunshot = coin_shot.instantiate()
				shots.add_child(gunshot)
				gunshot.send_facing(currently_facing)
				gunshot.global_position = global_position
				gunshot.global_position.x += 35 * currently_facing
				gunshot.global_position.y += 8
			elif shot_type == "blunderbuss":
				#I will come back and make this code dry, I will do it, yes I will
				coin_count -= 2
				hud.set_coin_counter(coin_count)
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
			elif shot_type == "cannon":
				coin_count -= 3
				hud.set_coin_counter(coin_count)
				cannon_sound.play()
				var cannonshot = coin_cannon_shot.instantiate()
				shots.add_child(cannonshot)
				cannonshot.send_facing(currently_facing)
				cannonshot.global_position = global_position
				cannonshot.global_position.x += 35 * currently_facing
				cannonshot.global_position.y += 8
				attack_timer = 2
			await get_tree().create_timer(.5).timeout
			shot.emitting = false
			shot.queue_free()
			attackShoot = false
		
func flip():
	if currently_facing == 1:
		canvas_layer.rotation = 0
	else:
		canvas_layer.rotation = 3.14
	
func add_coin():
	coin_count += 1
	hud.set_coin_counter(coin_count)
	change_weight()

func change_weight():
	jump_height = original_jump_height - (original_jump_height * (coin_count / 5) * .025)
	max_speed = original_max_speed - (original_max_speed * (coin_count / 5) * .025)

func changeCamera():
	var xBounds = 200
	var yBounds = 150
	var frames = 60.0
	
	if velocity.x > 0:
		idleTime = 0
		if cameraCounterX > 0:
			cameraCounterX += 1
		else:
			cameraCounterX += 2
	elif velocity.x < 0:
		idleTime = 0
		if cameraCounterX < 0:
			cameraCounterX -= 1
		else:
			cameraCounterX -= 2
	else:
		idleTime += 1
		if idleTime >= 60:
			if cameraCounterX > 0:
				cameraCounterX -= 1
				if cameraCounterX < 0:
					cameraCounterX = 0
			elif cameraCounterX < 0:
				cameraCounterX += 1
				if cameraCounterX > 0:
					cameraCounterX = 0
	if cameraCounterX > frames:
		cameraCounterX = frames
	elif cameraCounterX < -frames:
		cameraCounterX = -frames
	if cameraCounterX >= 0:
		camera.offset.x = (-cos(cameraCounterX / frames) + 1) * xBounds
	else:
		camera.offset.x = -(-cos(cameraCounterX / frames) + 1) * xBounds
	var zoom = cos(cameraCounterX / frames) / 2 + 1
	camera.zoom = Vector2(zoom, zoom)
	#print(zoom)
	#var yPixels = sin(velocity.y / max_fall_speed) * yBounds
	
	#if velocity.x > 0:
		#camera.offset.x = xPixels
	#elif velocity.x < 0:
		#if camera.offset.x < 0:
			#camera.offset.x -= xPixels
		#else:
			#camera.offset.x -= xPixels
		#if camera.offset.x < -xBounds:
			#camera.offset.x = -xBounds
	#else:
		#if camera.offset.x > 0:
			#camera.offset.x -= xPixels
			#if camera.offset.x < 0:
				#camera.offset.x = 0
		#else:
			#camera.offset.x += xPixels
			#if camera.offset.x > 0:
				#camera.offset.x = 0
				
	#if velocity.y > 0:
		#if camera.offset.y > 0:
			#camera.offset.y += yPixels
		#else:
			#camera.offset.y += yPixels
		#if camera.offset.y > yBounds:
			#camera.offset.y = yBounds
	#elif velocity.y < 0:
		#if camera.offset.y < 0:
			#camera.offset.y -= yPixels
		#else:
			#camera.offset.y -= yPixels
		#if camera.offset.y < -yBounds:
			#camera.offset.y = -yBounds
	#else:
		#if camera.offset.y > 0:
			#camera.offset.y -= yPixels
			#if camera.offset.y < 0:
				#camera.offset.y = 0
		#else:
			#camera.offset.y += yPixels
			#if camera.offset.y > 0:
				#camera.offset.y = 0

func hurt():
	lives -= 1
	hud.life_lost(lives)
	hurt_i_frames = 1
	if lives == 0:
		die()

func die():
	alive = false
	animated_sprite.play("die")
	await get_tree().create_timer(2).timeout
	velocity = Vector2.ZERO
	global_position = Vector2(178, 390)
	alive = true
	lives = 3
	hud.lives_gained(max_lives)

func respawn():
	alive = true
