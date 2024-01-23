extends Area2D

var player_facing = 1
var y_change = 0

func send_facing(current_facing):
	player_facing = current_facing

func set_change_y(y_amount):
	y_change = y_amount

func _physics_process(delta):
	if global_position.x > GlobalValues.playerPosition.x + 550:
		queue_free()
	elif global_position.x < GlobalValues.playerPosition.x - 550:
		queue_free()
	global_position.x += 20 * player_facing
	global_position.y += y_change


func _on_body_entered(body):
	var rand_rum = randi_range(0, 4)
	if body.is_in_group("enemy"):
		if (body.health - 1) == 0:
			GlobalValues.spawnCoinLocation = body.global_position
			if rand_rum == 0:
				GlobalValues.spawnRumLocation = body.global_position
		body.damage(1)
	queue_free()
