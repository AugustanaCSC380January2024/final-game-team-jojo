extends Area2D
var exploded = false

func _on_body_entered(body):
	var rand_rum = randi_range(0, 3)
	if body.is_in_group("enemy") && !exploded:
		exploded = true
		if (body.health - 5) <= 0:
			GlobalValues.spawnCoinLocation = body.global_position
			if rand_rum == 0:
				GlobalValues.spawnRumLocation = body.global_position
		body.damage(5)
