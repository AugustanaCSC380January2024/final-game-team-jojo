extends Area2D

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if (body.health - 5) == 0:
			GlobalValues.spawnCoinLocation = body.global_position
		body.damage(5)
