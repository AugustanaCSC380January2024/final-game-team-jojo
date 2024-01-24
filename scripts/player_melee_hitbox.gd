extends Area2D

@onready var hitbox_shape = $CollisionShape2D

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		if (body.health - 1) == 0:
			GlobalValues.spawnCoinLocation = body.global_position
		body.damage(1)


func _on_area_entered(area):
	if area.is_in_group("parry_projectile"):
		area.parried = true
		GlobalValues.player.melee_attack_timer = 0
		GlobalValues.player.parry()
		await get_tree().create_timer(1).timeout
		area.queue_free()
