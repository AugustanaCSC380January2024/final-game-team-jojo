extends CharacterBody2D

@onready var hitbox = preload("res://scenes/hitbox.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@export var gravity_strength = 500
var is_exploding = false
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
	
	if following:
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
		if global_position.x - 30 < player.global_position.x || global_position.x + 30 > player.global_position.x: attack()

func attack():
	animated_sprite.play("attack")
	await get_tree().create_timer(.3).timeout
	var attack_hitbox = hitbox.instantiate()
	add_child(attack_hitbox)
	await get_tree().create_timer(.2).timeout
	attack_hitbox.queue_free()


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
