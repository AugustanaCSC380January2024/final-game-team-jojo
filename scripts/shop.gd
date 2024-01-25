extends Control

@onready var rum_button = $shop_buttons/buy_rum
@onready var spring_button = $shop_buttons/buy_spring
@onready var wheels_button = $shop_buttons/buy_wheels
@onready var beans_button = $shop_buttons/buy_beans
@onready var barrels_button = $shop_buttons/buy_extrabarrel
@onready var loudener_button = $shop_buttons/buy_loudener
@onready var flag_button = $shop_buttons/buy_jollyroger
@onready var sword_button = $shop_buttons/buy_sword
@onready var start = $start_position
@onready var level_exit = $next_level
@export var left_limit = -10000000
@export var right_limit = 10000000
@export var top_limit = -10000000
@export var bottom_limit = 10000000

func _ready():
	AudioPlayer.change_music("shop")
	GlobalValues.player.in_shop = true
	GlobalValues.player.camera.limit_left = left_limit
	GlobalValues.player.camera.limit_right = right_limit
	GlobalValues.player.camera.limit_top = top_limit
	GlobalValues.player.camera.limit_bottom = bottom_limit
	GlobalValues.player.hud.levelTimer.visible = false

func _on_buy_rum_pressed():
	if GlobalValues.player.coin_count >= 30 && GlobalValues.extra_rum < 3:
		GlobalValues.extra_rum += 1
		GlobalValues.player.coin_count -= 30
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
		GlobalValues.player.max_lives += 1
		GlobalValues.player.lives = GlobalValues.player.max_lives
		GlobalValues.player.hud.create_lives_hud(GlobalValues.player.max_lives)
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

func _on_buy_beans_pressed():
	if GlobalValues.player.coin_count >= 80 && !GlobalValues.beans:
		GlobalValues.beans = true
		GlobalValues.player.coin_count -= 80
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.beans:
		beans_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 80:
		beans_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		beans_button.text = "JUMPING-BEANS-80"


func _on_buy_extrabarrel_pressed():
	if GlobalValues.player.coin_count >= 80 && !GlobalValues.extra_barrel:
		GlobalValues.extra_barrel = true
		GlobalValues.player.coin_count -= 80
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.extra_barrel:
		barrels_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 80:
		barrels_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		barrels_button.text = "DOUBLE-BARRELS-80"


func _on_buy_loudener_pressed():
	if GlobalValues.player.coin_count >= 80 && !GlobalValues.loudener:
		GlobalValues.loudener = true
		GlobalValues.player.coin_count -= 80
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.loudener:
		loudener_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 80:
		loudener_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		loudener_button.text = "LOUDENER-80"


func _on_buy_jollyroger_pressed():
	if GlobalValues.player.coin_count >= 150 && !GlobalValues.jolly_roger:
		GlobalValues.jolly_roger = true
		GlobalValues.player.coin_count -= 150
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.jolly_roger:
		flag_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 150:
		flag_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		flag_button.text = "JOLLY-ROGER-150"


func _on_buy_sword_pressed():
	if GlobalValues.player.coin_count >= 100 && !GlobalValues.sword:
		GlobalValues.sword = true
		GlobalValues.player.coin_count -= 100
		GlobalValues.player.hud.set_coin_counter(GlobalValues.player.coin_count)
	elif GlobalValues.sword:
		sword_button.text = "Out-O-Stock"
	elif GlobalValues.player.coin_count < 100:
		sword_button.text = "Not-Enough-Gold"
		await get_tree().create_timer(.5).timeout
		sword_button.text = "DREAD-PIRATE-BOB'S-SWORD-100"

func _on_exit_shop_pressed():
	GlobalValues.player.in_shop = false
	GlobalValues.playerPosition = start.global_position
	GlobalValues.player.hud.levelTimer.visible = true
	level_exit.next_level()
