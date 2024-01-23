extends CharacterBody2D


@onready var hitbox = preload("res://scenes/hitbox.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $death_sound
@export var gravity_strength = 500
@export var health = 1
var attack_timer = 0
var is_exploding = false
var following = false
var player = null

func _physics_process(delta):
	if attack_timer >= 0:
		attack_timer -= delta
	if global_position.y >= 700:
		queue_free()
	if !is_on_floor():
		if velocity.y > 0:
			gravity_strength = 1000
		velocity.y += gravity_strength * delta
		if velocity.y > 3000:
			velocity.y = 3000
	else: gravity_strength = 500
	
	if following:
		move_and_slide()
		if global_position.x - player.global_position.x > 60:
			animated_sprite.play("run")
			animated_sprite.flip_h = 1
			velocity.x = -150
		elif global_position.x - player.global_position.x < -60:
			animated_sprite.play("run")
			animated_sprite.flip_h = 0
			velocity.x = 150
			#await get_tree().create_timer(.3).timeout
		elif (global_position.x - 60 < player.global_position.x || global_position.x + 60 > player.global_position.x) && attack_timer <= 0:
			attack_timer = 2
			animated_sprite.play("attack")
			await get_tree().create_timer(.5).timeout
			var attack_hitbox = hitbox.instantiate()
			add_child(attack_hitbox)
			await get_tree().create_timer(.2).timeout
			attack_hitbox.queue_free()

func damage(damage_num):
	health -= damage_num
	if health <= 0:
		death_sound.play()
		queue_free()
		
func set_following():
	player = GlobalValues.player
	following = true

func _on_sight_radius_body_entered(body):
	if body.is_in_group("Player"):
		following = true
		player = body


func _on_wall_collision_detector_body_entered(body):
	if !body.is_in_group("enemy") && !body.is_in_group("Player"):
		velocity.y = -300
		animated_sprite.play("jump")
		await get_tree().create_timer(1).timeout
		velocity.y = 0
