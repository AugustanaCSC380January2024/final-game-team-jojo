extends CharacterBody2D


@onready var hitbox = preload("res://scenes/hitbox.tscn")
@onready var animated_sprite = $AnimatedSprite2D
@onready var death_sound = $death_sound
@onready var fear = preload("res://scenes/fear_symbol.tscn")
@export var gravity_strength = 500
@export var health = 1
var attack_timer = 0
var is_exploding = false
var following = false
var player = null
var afraid = false
var afraid_move_mult = 1
var fear_checked = false

func _physics_process(delta):
	if attack_timer >= 0:
		attack_timer -= delta
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
			if !afraid:
				animated_sprite.flip_h = 1
			elif afraid:
				animated_sprite.flip_h = 0
			velocity.x = -150 * afraid_move_mult
		elif global_position.x - player.global_position.x < -60:
			animated_sprite.play("run")
			if !afraid:
				animated_sprite.flip_h = 0
			elif afraid:
				animated_sprite.flip_h = 1
			velocity.x = 150 * afraid_move_mult
			#await get_tree().create_timer(.3).timeout
		elif (global_position.x - 60 < player.global_position.x || global_position.x + 60 > player.global_position.x) && attack_timer <= 0 && !afraid:
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
		GlobalValues.level_infamy += 1
		queue_free()
		
func set_following():
	player = GlobalValues.player
	following = true

func _on_sight_radius_body_entered(body):
	if body.is_in_group("Player"):
		if !fear_checked:
			var rand_fear = randi_range(1,100)
			if rand_fear <= (GlobalValues.infamy + GlobalValues.level_infamy)/3:
				afraid = true
				afraid_move_mult = -1
				display_fear()
			fear_checked = true
		following = true
		player = body

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
