extends Node2D

@onready var enemyCoin = preload("res://scenes/coin.tscn")

func _physics_process(delta):
	if GlobalValues.spawnCoinLocation != null:
		var coin = enemyCoin.instantiate()
		add_child(coin)
		coin.global_position = GlobalValues.spawnCoinLocation
		coin.fling_coin()
		GlobalValues.spawnCoinLocation = null

func _on_death_zone_body_entered(body):
	body.die()
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
	body.respawn()
