extends Area2D

@onready var coin_explosion = preload("res://scenes/coin_cannon_explosion.tscn")
var player_facing = 1
var y_change = 0
var speed = 20
var hit = false

func send_facing(current_facing):
	player_facing = current_facing

func set_change_y(y_amount):
	y_change = y_amount

func _physics_process(delta):
	if global_position.x > GlobalValues.playerPosition.x + 550 && !hit:
		hit = true
		explode()
	elif global_position.x < GlobalValues.playerPosition.x - 550 && !hit:
		hit = true
		explode()
	global_position.x += speed * player_facing
	global_position.y += y_change

func explode():
	speed = 0
	var coin_explosion_instance = coin_explosion.instantiate()
	add_child(coin_explosion_instance)
	print("Explode")
	await get_tree().create_timer(.9).timeout
	queue_free()

func _on_body_entered(body):
	var rand_rum = randi_range(0, 3)
	if body.is_in_group("enemy") && !hit:
		if !GlobalValues.loudener:
			if (body.health - 5) <= 0:
				GlobalValues.spawnCoinLocation = body.global_position
				if rand_rum == 0:
					GlobalValues.spawnRumLocation = body.global_position
			body.damage(5)
		elif GlobalValues.loudener:
			if (body.health - 10) <= 0:
				GlobalValues.spawnCoinLocation = body.global_position
				if rand_rum == 0:
					GlobalValues.spawnRumLocation = body.global_position
			body.damage(10)
	hit = true
	explode()
