extends CharacterBody2D

@onready var explosion_hitbox = preload("res://scenes/nuclear_explosion_hitbox.tscn")
@onready var explosion_sfx = $nuclear_explosion_sfx
@onready var animated_sprite = $enemy_animation
@onready var explosion_sprite = $nuclear_explosion_animation
@export var gravity_strength = 500
var is_exploding = false
var alive = true
var following = false
var player = null

func _physics_process(delta):
	if global_position.y >= 700:
		queue_free()
	if !is_on_floor():
		velocity.y += gravity_strength * delta
		if velocity.y > 1000:
			velocity.y = 1000
	if following && alive:
		if global_position.x - player.global_position.x > 20:
			animated_sprite.play("run")
			animated_sprite.flip_h = 1
			velocity.x = -100
			move_and_slide()
		elif global_position.x - player.global_position.x < -20:
			animated_sprite.play("run")
			animated_sprite.flip_h = 0
			velocity.x = 100
			move_and_slide()
			#await get_tree().create_timer(.3).timeout
		else: attack()

func attack():
	is_exploding = true
	explosion_sprite.play("nuclear_explosion")
	explosion_sfx.play()
	var attack_hitbox = explosion_hitbox.instantiate()
	add_child(attack_hitbox)
	animated_sprite.play("explode")
	alive = false
	await get_tree().create_timer(2).timeout
	attack_hitbox.queue_free()
	queue_free()


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