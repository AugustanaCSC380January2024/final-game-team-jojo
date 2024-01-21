extends Control

@onready var rum_button = $shop_buttons/buy_rum
@onready var spring_button = $shop_buttons/buy_spring
@onready var wheels_button = $shop_buttons/buy_wheels
@onready var level_exit = $next_level
@export var left_limit = -10000000
@export var right_limit = 10000000
@export var top_limit = -10000000
@export var bottom_limit = 10000000

func _ready():
	GlobalValues.player.gravity_strength = 0
	GlobalValues.player.alive = false
	GlobalValues.player.camera.limit_left = left_limit
	GlobalValues.player.camera.limit_right = right_limit
	GlobalValues.player.camera.limit_top = top_limit
	GlobalValues.player.camera.limit_bottom = bottom_limit

func _on_buy_rum_pressed():
	if GlobalValues.player.coin_count >= 30 && GlobalValues.extra_rum < 3:
		GlobalValues.extra_rum += 1
		GlobalValues.player.coin_count -= 30
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
		GlobalValues.player.max_lives += 1
		GlobalValues.player.lives += 1
		GlobalValues.player.hud.lives_gained(GlobalValues.player.max_lives)
	elif GlobalValues.extra_rum == 3:
		rum_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 30:
		rum_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		rum_button.text = "Rum-30-Limit-3"

func _on_buy_spring_pressed():
	if GlobalValues.player.coin_count >= 80 && !GlobalValues.spring_leg:
		GlobalValues.spring_leg = true
		GlobalValues.player.coin_count -= 80
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.spring_leg:
		spring_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 80:
		spring_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		spring_button.text = "Springleg-80"

func _on_buy_wheels_pressed():
	if GlobalValues.player.coin_count >= 80 && !GlobalValues.wheelboots:
		GlobalValues.wheelboots = true
		GlobalValues.player.coin_count -= 80
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.wheelboots:
		wheels_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 80:
		wheels_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		wheels_button.text = "Wheelboots-80"


func _on_exit_shop_pressed():
	GlobalValues.player.alive = true
	level_exit.next_level()
