extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var acceleration = 2000
@export var max_speed = 500
@export var jump_height = 600
@export var gravity_strength = 980
@export var friction = 1500

func _physics_process(delta):
	if is_on_floor() == false:
		if Input.is_action_just_pressed("melee"):
			animated_sprite.play("jump_melee")
		elif Input.is_action_just_pressed("shoot"):
			animated_sprite.play("jump_gun")
		else:
			animated_sprite.play("jump")
		velocity.y += gravity_strength * delta
		if velocity.y > 1000:
			velocity.y = 1000
	if is_on_floor() == true:
		if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			if Input.is_action_just_pressed("melee"):
				animated_sprite.play("run_melee")
			elif Input.is_action_just_pressed("shoot"):
				animated_sprite.play("run_n_gun")
			else:
				animated_sprite.play("run")
		else:
			if Input.is_action_just_pressed("melee"):
				animated_sprite.play("melee")
			elif Input.is_action_just_pressed("shoot"):
				animated_sprite.play("gun")
			else:
				animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("jump") && is_on_floor()==true:
			jump(jump_height)
			
	if Input.is_action_just_pressed("move_down") && is_on_floor()==false:
			velocity.y += 500
	
	var facing = 0
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
