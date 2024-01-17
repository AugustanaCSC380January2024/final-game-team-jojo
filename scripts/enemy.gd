extends CharacterBody2D

@onready var hitbox = preload("res://scenes/hitbox.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@export var gravity_strength = 500
var following = false
var player = null

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity_strength * delta
		if velocity.y > 1000:
			velocity.y = 1000
	if following:
		if global_position.x - player.global_position.x > 20:
			animated_sprite.flip_h = -1
			velocity.x = -50
			move_and_slide()
		elif global_position.x - player.global_position.x < -20:
			animated_sprite.flip_h = 1
			velocity.x = 50
			move_and_slide()
		else: attack()

func attack():
	animated_sprite.play("attack")
	await get_tree().create_timer(.3).timeout
	var attack_hitbox = hitbox.instantiate()
	add_child(attack_hitbox)
	await get_tree().create_timer(.2).timeout
	attack_hitbox.queue_free()


func _on_sight_radius_body_entered(body):
	print("entered")
	if body.is_in_group("Player"):
		following = true
		player = body
		print("player entered")
