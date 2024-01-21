extends Node2D

@onready var enemyCoin = preload("res://scenes/coin.tscn")
@export var following_level: PackedScene = null
@export var level_underwater = false
@export var level_gravity = 980
var physics_set = false

func _ready():
	GlobalValues.next_level = following_level
	GlobalValues.player.underwater = level_underwater
	GlobalValues.player.gravity_strength = level_gravity
	GlobalValues.player.limit_left = left_limit
	GlobalValues.player.limit_right = right_limit
	GlobalValues.player.limit_up = up_limit
	GlobalValues.player.limit_down = down_limit

func _physics_process(delta):
	if GlobalValues.spawnCoinLocation != null:
		var num = 3
		for i in range(num):
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
