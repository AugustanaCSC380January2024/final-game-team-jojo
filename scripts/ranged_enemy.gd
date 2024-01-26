extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var bomb = preload("res://scenes/bomb.tscn")
@onready var fear = preload("res://scenes/fear_symbol.tscn")
@export var gravity_strength = 500
@onready var hurt_sound = $hurt_sound
var health = 1
var alive = true
var is_exploding = false
var attacking = false
var attack_timer = 2
var afraid = false
var fear_checked = false

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
	if attack_timer <= 0 && !afraid:
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
	hurt_sound.play()
	if health <= 0 && alive:
		alive = false
		GlobalValues.player.addCombo()
		GlobalValues.level_infamy += 1
		queue_free()

func _on_sight_radius_body_entered(body):
	if body.is_in_group("Player"):
		if !fear_checked:
			var rand_fear = randi_range(1,100)
			if rand_fear <= (GlobalValues.infamy + GlobalValues.level_infamy)/3:
				afraid = true
				display_fear()
			fear_checked = true
		if body.global_position.x < global_position.x:
			animated_sprite.flip_h = 1
		attacking = true

func display_fear():
	var fear_indicator = fear.instantiate()
	add_child(fear_indicator)
	fear_indicator.global_position.y -= 50

func _on_wall_collision_detector_body_entered(body):
	if !body.is_in_group("enemy") && !body.is_in_group("Player"):
		velocity.y = -300
		animated_sprite.play("jump")
		await get_tree().create_timer(1).timeout
		velocity.y = 0


func _on_sight_radius_body_exited(body):
	if body.is_in_group("Player"):
		attacking = false
