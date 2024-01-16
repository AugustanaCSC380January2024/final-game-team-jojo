extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var move_speed = 400
@export var jump_height = 400

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && is_on_floor()==true:
			jump(jump_height)
	var facing = 0
	facing = Input.get_axis("move_left","move_right")
	#if facing != 0:
	#	animated_sprite.flip_h = (facing == -1)
	velocity.x = facing * move_speed
	move_and_slide()

func jump(jump_height):
	velocity.y = -jump_height
