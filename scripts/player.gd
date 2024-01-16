extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var shoot_particles = preload("res://scenes/shoot_particles.tscn")

@export var acceleration = 2000
@export var max_speed = 500
@export var jump_height = 600
@export var gravity_strength = 980
@export var friction = 1500
var alive = true
var attackShoot = false
var attackMelee = false

func _physics_process(delta):
	if !is_on_floor():
		#if alive:
			#if Input.is_action_pressed("melee"):
				#animated_sprite.play("jump_melee")
			#elif Input.is_action_pressed("shoot"):
				#animated_sprite.play("jump_gun")
			#else:
				#animated_sprite.play("jump")
		velocity.y += gravity_strength * delta
		if velocity.y > 1000:
			velocity.y = 1000
	
	#if is_on_floor() && alive:
		#if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			#if Input.is_action_pressed("melee"):
				#animated_sprite.play("run_melee")
			#elif Input.is_action_pressed("shoot"):
				#animated_sprite.play("run_n_gun")
			#else:
				#animated_sprite.play("run")
		#else:
			#if Input.is_action_pressed("melee"):
				#animated_sprite.play("melee")
			#elif Input.is_action_pressed("shoot"):
				#animated_sprite.play("gun")
			#else:
				#animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("jump") && is_on_floor()==true:
		jump(jump_height)
	if Input.is_action_just_pressed("move_down") && is_on_floor()==false:
		velocity.y += 500
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("melee"):
		melee()
	idle()
	
	var facing = 0
	if alive:
		facing = Input.get_axis("move_left","move_right")
	if facing != 0:
		animated_sprite.flip_h = (facing == -1)
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
		add_child(shot)
		await get_tree().create_timer(0.216).timeout
		shot.emitting = true
		await get_tree().create_timer(0.3).timeout
		shot.emitting = false
		shot.queue_free()
		attackShoot = false
	
func die():
	alive = false
	animated_sprite.play("die")

func respawn():
	alive = true
