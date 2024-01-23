extends CharacterBody2D

@onready var explosion_hitbox = preload("res://scenes/normal_explosion_hitbox.tscn")
@onready var explosion_sfx = $explosion_sound
@onready var animated_sprite = $enemy_animation
@onready var explosion_sprite = $explosion_animation
@export var gravity_strength = 500
var health = 1
var is_exploding = false
var alive = true
var following = false
var player = null

func _physics_process(delta):
	if global_position.y >= 700:
		queue_free()
	if !is_on_floor():
		if velocity.y > 0:
			gravity_strength = 1000
		velocity.y += gravity_strength * delta
		if velocity.y > 3000:
			velocity.y = 3000
	else: gravity_strength = 500
	
	if following && alive:
		move_and_slide()
		if global_position.x - player.global_position.x > 60:
			animated_sprite.play("run")
			animated_sprite.flip_h = 1
			velocity.x = -300
		elif global_position.x - player.global_position.x < -60:
			animated_sprite.play("run")
			animated_sprite.flip_h = 0
			velocity.x = 300
		elif (global_position.x - 60 < player.global_position.x || global_position.x + 60 > player.global_position.x) && (global_position.y - 60 < player.global_position.y || global_position.y + 60 < player.global_position.y) && alive:
			alive = false
			await get_tree().create_timer(.5).timeout
			is_exploding = true
			explosion_sprite.play("explosion")
			explosion_sfx.play()
			var attack_hitbox = explosion_hitbox.instantiate()
			add_child(attack_hitbox)
			animated_sprite.play("explode")
			await get_tree().create_timer(1).timeout
			attack_hitbox.queue_free()
			queue_free()
	
	
func damage(damage_num):
	health -= damage_num
	if health <= 0:
		queue_free()

func _on_sight_radius_body_entered(body):
	print("entered")
	if body.is_in_group("Player"):
		following = true
		player = body
		print("player entered")


func _on_wall_collision_detector_body_entered(body):
	print(body)
	if !body.is_in_group("enemy") && !body.is_in_group("Player"):
		velocity.y = -300
		animated_sprite.play("jump")
		await get_tree().create_timer(1).timeout
		velocity.y = 0
