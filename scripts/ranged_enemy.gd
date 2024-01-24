extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var bomb = preload("res://scenes/bomb.tscn")
@export var gravity_strength = 500
var health = 1
var is_exploding = false
var attacking = false
var attack_timer = 2

func _physics_process(delta):
	if attacking && attack_timer > 0:
		attack_timer -= delta
	if !is_on_floor():
		if velocity.y > 0:
			gravity_strength = 1000
		velocity.y += gravity_strength * delta
		if velocity.y > 3000:
			velocity.y = 3000
	else: gravity_strength = 500
	if attack_timer <= 0:
		attack()

func attack():
	attack_timer = 2
	animated_sprite.play("throw_bomb")
	await get_tree().create_timer(.5).timeout
	var thrown_bomb = bomb.instantiate()
	add_child(thrown_bomb)
	thrown_bomb.global_position = global_position
	thrown_bomb.aim(global_position)
	await get_tree().create_timer(.5).timeout
	animated_sprite.play("idle")

func damage(damage_num):
	health -= damage_num
	if health <= 0:
		GlobalValues.level_infamy += 1
		queue_free()

func _on_sight_radius_body_entered(body):
	if body.is_in_group("Player"):
		if body.global_position.x < global_position.x:
			animated_sprite.flip_h = 1
		attacking = true
		print("seen")


func _on_wall_collision_detector_body_entered(body):
	if !body.is_in_group("enemy") && !body.is_in_group("Player"):
		velocity.y = -300
		animated_sprite.play("jump")
		await get_tree().create_timer(1).timeout
		velocity.y = 0


func _on_sight_radius_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false
		print("seen")
