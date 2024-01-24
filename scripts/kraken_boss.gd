extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
@onready var explosion_sfx = $exploded_ship
@onready var ship_destroyed_sfx = $ship_destroyed
@onready var change_level = $next_level
@onready var tentacle = preload("res://scenes/kraken_tentacle.tscn")
@onready var lightning = preload("res://scenes/kraken_lightning.tscn")
@onready var crewmate = preload("res://scenes/bomb_enemy.tscn")
var attacking = false
var alive = true
var attack_timer = 3
var health = 1

func _physics_process(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		random_attack()
		attack_timer = 3
	move_and_slide()

func random_attack():
	if attacking && alive:
		var rng = RandomNumberGenerator.new()
		var random_index = rng.randi_range(0, 2)
		print(random_index)
		if random_index == 0:
			kraken_lighting()
		if random_index == 1:
			kraken_walk()
		if random_index == 2:
			tentacle_attack()
		if random_index == 3:
			crew_attack()

func kraken_lighting():
	var lighting_attack = lightning.instantiate()
	add_child(lighting_attack)
	lighting_attack.global_position.x = GlobalValues.playerPosition.x

func kraken_walk():
	velocity.x = -400
	await get_tree().create_timer(3).timeout
	velocity.x = 600
	await get_tree().create_timer(3).timeout
	velocity.x = 0
func tentacle_attack():
	var attacking_tentacle = tentacle.instantiate()
	add_child(attacking_tentacle)
	await get_tree().create_timer(5).timeout
	attacking_tentacle.queue_free()

func crew_attack():
	var attacking_crew = crewmate.instantiate()
	var attacking_crew2 = crewmate.instantiate()
	var attacking_crew3 = crewmate.instantiate()
	add_child(attacking_crew)
	add_child(attacking_crew2)
	add_child(attacking_crew3)
	attacking_crew.global_position.y = global_position.y 
	attacking_crew2.global_position.y = global_position.y
	attacking_crew3.global_position.y = global_position.y
	attacking_crew.global_position.x = global_position.x
	attacking_crew2.global_position.x = global_position.x
	attacking_crew3.global_position.x = global_position.x
	
func damage(damage_num):
	health -= damage_num
	if health <= 0 && alive:
		attack_timer = 100000
		animation.play("died")
		alive = false
		explosion_sfx.play()
		print("Next")
		await get_tree().create_timer(1).timeout
		ship_destroyed_sfx.play()
		await get_tree().create_timer(2).timeout
		GlobalValues.level_infamy += 10
		change_level.next_level()
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") && alive:
		if body.hurt_i_frames <= 0:
			body.hurt()


func _on_area_2d_2_body_entered(body):
	attacking = true
