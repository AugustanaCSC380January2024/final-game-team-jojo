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
@onready var hud = $CanvasLayer2/HUD
@onready var camera = $Camera2D
@onready var damage_audio = $damage_audio
@onready var parry_sound = $parry
@onready var combo_timer = $ComboTimer
@onready var level_timer = $LevelTimer

@export var swim_jump_timer = 0
@export var underwater = false
@export var hurt_i_frames = 0
@export var max_lives = 3
@export var lives = 3
@export var coin_count = 5
@export var acceleration = 2000
@export var original_jump_height = 500
@export var original_max_speed = 500
@export var max_speed = 750
@export var jump_height = 500
@export var max_fall_speed = 2000
@export var gravity_strength = 980
@export var friction = 2500
@export var attack_timer = 1
@export var melee_attack_timer = 1
@export var jump_window = 15.0
@export var max_combo_time = 3.5
var jump_window_counter = 0.0
var in_shop = false
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
var jumping = false
var beans_jump = false
var combo = false
var comboNum = 0
var maxLevelTimer = 180
var canAttack = false
var canAttackTimer = 1

func _ready():
	set_floor_max_angle(PI/3)
	hud.set_coin_counter(coin_count)
	max_lives += GlobalValues.extra_rum
	lives = max_lives
	hud.create_lives_hud(max_lives)
	if GlobalValues.beans:
		beans_jump = true

func _physics_process(delta):
	if canAttackTimer <= 0:
		canAttack = true
		canAttackTimer = 0
	else:
		canAttackTimer -= delta
	hud.set_level_timer(level_timer.time_left)
	if underwater:
		if swim_jump_timer > 0:
			swim_jump_timer -= delta
		elif swim_jump_timer <= 0:
			beans_jump = true
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
	if !is_on_floor() && !jumping:
		if velocity.y > 0:
			velocity.y += 8
		velocity.y += gravity_strength * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	elif !jumping:
		coyote_time = 0.1
		if GlobalValues.beans:
			beans_jump = true
	if Input.is_action_just_pressed("jump") && alive && !underwater:
		if(is_on_floor() || coyote_time > 0 || beans_jump):
			jumping = true
			jump_window_counter = 0
			if(!is_on_floor() && coyote_time <= 0):
				beans_jump = false
			jump(jump_height)
			jump_buffer = 0.0
			coyote_time = 0.0
		else:
			jump_buffer = 0.1
		
	elif Input.is_action_just_pressed("jump") && alive && underwater:
		if swim_jump_timer <= 0 || beans_jump:
			jumping = true
			jump_window_counter = 0
			if swim_jump_timer > 0 && beans_jump:
				beans_jump = false
			jump(jump_height)
			jump_buffer = 0.0
			swim_jump_timer = 1
		else:
			jump_buffer = 0.1
	if Input.is_action_pressed("jump") && jumping:
		jump_window_counter += 1
		if jump_window_counter >= 10:
			jump(jump_height)
			jumping = false
			jump_window_counter = 0
	if Input.is_action_just_released("jump") && jumping:
		jump(jump_height * ((jump_window_counter / (jump_window)) * 2/3 + 1/3))
		jumping = false
		jump_window_counter = 0
		
	if Input.is_action_just_pressed("move_down") && !is_on_floor():
		velocity.y += 500
	if Input.is_action_just_pressed("shoot") && !in_shop:
		shoot()
	if Input.is_action_just_pressed("melee"):
		melee()
	if Input.is_action_just_pressed("select_flintlock"):
		shot_type = "flintlock"
	if Input.is_action_just_pressed("select_blunderbuss"):
		shot_type = "blunderbuss"
	if Input.is_action_just_pressed("select_cannon"):
		shot_type = "cannon"
	if Input.is_action_just_pressed("reset"):
		die()
	idle()
	
	if alive:
		facing = Input.get_axis("move_left","move_right")
	if facing != 0 and alive:
		animated_sprite.flip_h = (facing == -1)
		currently_facing = facing
		if GlobalValues.wheelboots:
			velocity.x += facing * acceleration * delta * 2
		else:
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
	if GlobalValues.wheelboots:
		if velocity.x > max_speed * 2:
			velocity.x = max_speed * 2
		elif velocity.x < -max_speed * 2:
			velocity.x = -max_speed * 2
	else:
		if velocity.x > max_speed:
			velocity.x = max_speed
		elif velocity.x < -max_speed:
			velocity.x = -max_speed
	flip()
	GlobalValues.playerPosition = global_position
	move_and_slide()

func jump(jump_height):
	if GlobalValues.spring_leg:
		velocity.y = -jump_height * 2
	else:
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
	if alive && !attackShoot && melee_attack_timer <= 0 && canAttack:
		melee_attack_timer = 1
		attackMelee = true
		canAttack = false
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
		await get_tree().create_timer(0.2).timeout
		attack_hitbox.queue_free()
		attackMelee = false
		
		
func shoot():
	if alive && !attackMelee && attack_timer <= 0 && canAttack:
		if (shot_type == "flintlock" && coin_count >= 1) || (shot_type == "blunderbuss" && coin_count >= 3) || (shot_type == "cannon" && coin_count >= 5): #add no ammo indicator
			attackShoot = true
			if is_on_floor():
				if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
					animated_sprite.play("run_n_gun")
				else:
					animated_sprite.play("gun")
			else:
				animated_sprite.play("jump_gun")
				
			#var shot = shoot_particles.instantiate()
			#canvas_layer.add_child(shot)
			if !GlobalValues.extra_barrel:
				attack_timer = 1
			elif GlobalValues.extra_barrel:
				attack_timer = .5
			#shot.emitting = true
			if shot_type == "flintlock":
				coin_count -= 1
				hud.set_coin_counter(coin_count)
				change_weight()
				gunshot_sound.play()
				var gunshot = coin_shot.instantiate()
				shots.add_child(gunshot)
				gunshot.send_facing(currently_facing)
				gunshot.global_position = global_position
				gunshot.global_position.x += 35 * currently_facing
				gunshot.global_position.y += 8
			elif shot_type == "blunderbuss":
				#I will come back and make this code dry, I will do it, yes I will
				coin_count -= 3
				hud.set_coin_counter(coin_count)
				change_weight()
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
				coin_count -= 5
				hud.set_coin_counter(coin_count)
				change_weight()
				cannon_sound.play()
				var cannonshot = coin_cannon_shot.instantiate()
				shots.add_child(cannonshot)
				cannonshot.send_facing(currently_facing)
				cannonshot.global_position = global_position
				cannonshot.global_position.x += 35 * currently_facing
				cannonshot.global_position.y += 8
				if !GlobalValues.extra_barrel:
					attack_timer = 2
				elif GlobalValues.extra_barrel:
					attack_timer = 1
			await get_tree().create_timer(.5).timeout
			#shot.emitting = false
			#shot.queue_free()
			attackShoot = false
		
func flip():
	if currently_facing == 1:
		canvas_layer.rotation = 0
	else:
		canvas_layer.rotation = PI
	
func add_coin():
	coin_count += 1
	hud.set_coin_counter(coin_count)
	change_weight()
	
func add_rum():
	if lives < max_lives:
		lives += 1
		hud.lives_gained(lives)

func change_weight():
	jump_height = original_jump_height - (original_jump_height * (coin_count / 10.0) * .025)
	max_speed = original_max_speed - (original_max_speed * (coin_count / 10.0) * .025)
	if underwater:
		gravity_strength = 600 + ((coin_count / 10) * 20)

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
		camera.offset.x = (-cos(cameraCounterX / frames * PI / 2) + 1) * xBounds
	else:
		camera.offset.x = -(-cos(cameraCounterX / frames  * PI / 2) + 1) * xBounds
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

func parry():
	parry_sound.play()
	addCombo()

func hurt():
	if hurt_i_frames <= 0:
		damage_audio.play()
		lives -= 1
		hud.life_lost(lives)
		hurt_i_frames = 1
		if lives <= 0:
			die()
		else:
			for i in range(10):
				animated_sprite.visible = false
				await get_tree().create_timer(0.05).timeout
				animated_sprite.visible = true
				await get_tree().create_timer(0.05).timeout
			
func startCombo():
	if !combo:
		combo = true
		comboNum = 1
		hud.set_combo_count(comboNum)
		hud.set_combo_visibility(combo)
		combo_timer.wait_time = max_combo_time
		combo_timer.start()

func addCombo():
	if combo:
		comboNum += 1
		if comboNum == 5:
			AudioPlayer.change_music("combo_music", GlobalValues.current_level_music)
		hud.set_combo_count(comboNum)
		combo_timer.wait_time = max_combo_time
		combo_timer.start()
	else:
		startCombo()

func endCombo():
	if combo:
		if comboNum >= 5:
			AudioPlayer.change_music(GlobalValues.current_level_music, GlobalValues.current_level_music)
		combo = false
		hud.set_combo_count(0)
		hud.set_combo_visibility(false)
		coin_count += ceili(pow(comboNum, 1.5))
		hud.set_coin_counter(coin_count)
		change_weight()
		comboNum = 0
	
func _on_combo_timer_timeout():
	endCombo()

func setLevelTimer(time):
	maxLevelTimer = time
	level_timer.wait_time = time
	level_timer.start()
	hud.set_timer_visibility(true)

func stopTimer():
	print(level_timer.time_left)
	coin_count += ceili(level_timer.time_left * 3)
	level_timer.stop()
	print(level_timer.time_left)
	hud.set_coin_counter(coin_count)
	change_weight()
	hud.set_timer_visibility(false)

func _on_level_timer_timeout():
	hud.set_timer_visibility(false)

func die():
	if alive:
		endCombo()
		alive = false
		animated_sprite.play("die")
		level_timer.stop()
		print(level_timer.is_stopped())
		await get_tree().create_timer(2).timeout
		velocity = Vector2.ZERO
		global_position = Vector2(178, 390)
		AudioPlayer.restart()
		GlobalValues.level_infamy = 0
		get_tree().reload_current_scene()
		alive = true
		lives = max_lives
		hud.lives_gained(max_lives)
		level_timer.wait_time = maxLevelTimer
		level_timer.start()

func respawn():
	alive = true
