extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
@onready var explosion_sfx = $exploded_ship
@onready var ship_destroyed_sfx = $ship_destroyed
@onready var hurt_sound = $hurt_sound
@onready var change_level = $next_level
@onready var bomb = preload("res://scenes/bomb.tscn")
@onready var cannonball = preload("res://scenes/cannonball.tscn")
@onready var crewmate = preload("res://scenes/melee_enemy.tscn")
@onready var nuke = preload("res://scenes/nuclear_boss_cannonball.tscn")
var attack_timer = 0.5
var health = 100
var attacking = false

func _physics_process(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		random_attack()
		attack_timer = 1.5

func random_attack():
	if attacking:
		var rng = RandomNumberGenerator.new()
		var random_index = rng.randi_range(0, 9)
		print(random_index)
		if random_index in range(0, 2):
			bomb_wave()
		if random_index in range(3, 5):
			cannon_volley()
		if random_index in range(6, 8):
			crew_attack()
		if random_index == 9:
			nuclear_cannon()
	else:
		pass

func cannon_volley():
	var fired_cannonball = cannonball.instantiate()
	var fired_cannonball2 = cannonball.instantiate()
	var fired_cannonball3 = cannonball.instantiate()
	var fired_cannonball4 = cannonball.instantiate()
	var fired_cannonball5 = cannonball.instantiate()
	add_child(fired_cannonball)
	add_child(fired_cannonball2)
	add_child(fired_cannonball3)
	add_child(fired_cannonball4)
	add_child(fired_cannonball5)
	#fired_cannonball.cannon_speed = 300
	#fired_cannonball2.cannon_speed = 300
	#fired_cannonball3.cannon_speed = 300
	#fired_cannonball4.cannon_speed = 300
	#fired_cannonball5.cannon_speed = 300
	fired_cannonball2.global_position.x = global_position.x - 300
	fired_cannonball3.global_position.x = global_position.x - 600
	fired_cannonball4.global_position.x = global_position.x + 300
	fired_cannonball5.global_position.x = global_position.x + 600
	fired_cannonball2.changeAngle()
	fired_cannonball3.changeAngle()
	fired_cannonball4.changeAngle()
	fired_cannonball5.changeAngle()

func bomb_wave():
	var fired_bomb = bomb.instantiate()
	var fired_bomb2 = bomb.instantiate()
	var fired_bomb3 = bomb.instantiate()
	var fired_bomb4 = bomb.instantiate()
	var fired_bomb5 = bomb.instantiate()
	add_child(fired_bomb)
	add_child(fired_bomb2)
	add_child(fired_bomb3)
	add_child(fired_bomb4)
	add_child(fired_bomb5)
	fired_bomb.bomb_speed = -150
	fired_bomb2.bomb_speed = -150
	fired_bomb3.bomb_speed = -150
	fired_bomb4.bomb_speed = -150
	fired_bomb5.bomb_speed = -150
	fired_bomb.global_position = global_position
	fired_bomb.global_position.y = global_position.y + 600
	fired_bomb2.global_position = global_position
	fired_bomb2.global_position.y = global_position.y + 575
	fired_bomb3.global_position = global_position
	fired_bomb3.global_position.y = global_position.y + 500
	fired_bomb4.global_position = global_position
	fired_bomb4.global_position.y = global_position.y + 525
	fired_bomb5.global_position = global_position
	fired_bomb5.global_position.y = global_position.y + 550
	fired_bomb.aim(global_position)
	fired_bomb2.aim(global_position)
	fired_bomb3.aim(global_position)
	fired_bomb4.aim(global_position)
	fired_bomb5.aim(global_position)

func crew_attack():
	var attacking_crew = crewmate.instantiate()
	var attacking_crew2 = crewmate.instantiate()
	var attacking_crew3 = crewmate.instantiate()
	add_child(attacking_crew)
	add_child(attacking_crew2)
	add_child(attacking_crew3)
	attacking_crew.set_following()
	attacking_crew2.set_following()
	attacking_crew3.set_following()
	attacking_crew.global_position.y = global_position.y + 500
	attacking_crew2.global_position.y = global_position.y + 500
	attacking_crew3.global_position.y = global_position.y + 500
	attacking_crew.global_position.x = global_position.x - 25
	attacking_crew2.global_position.x = global_position.x - 75
	attacking_crew3.global_position.x = global_position.x - 50
	
func nuclear_cannon():
	var fired_nuke = nuke.instantiate()
	add_child(fired_nuke)
	fired_nuke.global_position.y += 500
	
func damage(damage_num):
	health -= damage_num
	hurt_sound.play()
	if health <= 0:
		GlobalValues.level_infamy += 10
		attack_timer = 100000
		animation.play("explode")
		explosion_sfx.play()
		animation.scale = Vector2(6,6)
		await get_tree().create_timer(1).timeout
		ship_destroyed_sfx.play()
		await get_tree().create_timer(4).timeout
		change_level.next_level()
		queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		attacking = true
		AudioPlayer.change_music("boss", "level3")
		GlobalValues.current_level_music = "boss"
