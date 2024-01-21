extends Node2D

@onready var enemyCoin = preload("res://scenes/coin.tscn")
@onready var startPos = $start_position
@onready var levelMusic = $Level
@onready var bossMusic = $Boss
@export var following_level: PackedScene = null
@export var level_underwater = false
@export var level_gravity = 980
@export var left_limit = -10000000
@export var right_limit = 10000000
@export var top_limit = -10000000
@export var bottom_limit = 10000000
var physics_set = false

func _ready():
	levelMusic.play()
	GlobalValues.next_level = following_level
	GlobalValues.player.underwater = level_underwater
	GlobalValues.player.gravity_strength = level_gravity
	GlobalValues.player.camera.limit_left = left_limit
	GlobalValues.player.camera.limit_right = right_limit
	GlobalValues.player.camera.limit_top = top_limit
	GlobalValues.player.camera.limit_bottom = bottom_limit
	GlobalValues.player.global_position = startPos.global_position
	

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


func _on_area_2d_body_entered(body):
	levelMusic.stop()
	bossMusic.play()
