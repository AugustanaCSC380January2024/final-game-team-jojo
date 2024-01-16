extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var move_speed = 400
@export var jump_height = 700
@export var gravity_strength = 900

func _physics_process(delta):
	if is_on_floor()==false:
		velocity.y += gravity_strength * delta
		if velocity.y > 500:
			velocity.y = 500
			
	if is_on_floor()==true:
		animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("jump") && is_on_floor()==true:
			jump(jump_height)
			
	if Input.is_action_just_pressed("move_down") && is_on_floor()==false:
			velocity.y += 500
	
	var facing = 0
	facing = Input.get_axis("move_left","move_right")
	if facing != 0:
		animated_sprite.flip_h = (facing == -1)
	velocity.x = facing * move_speed
	move_and_slide()

func jump(jump_height):
	animated_sprite.play("jump")
	velocity.y = -jump_height
