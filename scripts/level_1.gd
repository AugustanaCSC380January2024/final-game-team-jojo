extends Node2D

func _on_death_zone_body_entered(body):
	body.die()
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
	body.respawn()
