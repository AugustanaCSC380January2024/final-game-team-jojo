extends Control

@onready var rum = $rum
@onready var rum2 = $rum2
@onready var rum3 = $rum3
@onready var rum4 = $rum4
@onready var rum5 = $rum5
@onready var rum6 = $rum6
@onready var empty_rum = preload("res://assets/Treasure Hunters/Treasure Hunters/Pirate Treasure/Sprites/Red Potion/03.png")
@onready var full_rum = preload("res://assets/Treasure Hunters/Treasure Hunters/Pirate Treasure/Sprites/Red Potion/07.png")
@onready var coin_count = $coin_counter
@onready var combo = $combo
@onready var comboCounter = $combo/combo_counter
@onready var comboTimer = $ComboTimer
@onready var levelTimer = $level_timer

var combo_label_size = 1
var combo_alpha = 1
var combo_animation = false

func _ready():
	rum4.visible = false
	rum5.visible = false
	rum6.visible = false

func _process(delta):
	if combo.visible:
		if combo_animation:
			if combo_label_size > 1 && combo_alpha < 1:
				combo_label_size -= 5 * delta
				combo_alpha += 5 * delta
			else:
				combo_label_size = 1.1
				combo_alpha = 1
				combo_animation = false
		else:
			if combo_label_size > 1:
				combo_label_size -= delta / 4
			else:
				combo_label_size = 1.1
		combo.scale = Vector2(combo_label_size, combo_label_size)
		combo.modulate = Color(1, 1, 1, combo_alpha)
	
func create_lives_hud(max_lives):
	if max_lives >= 4:
		rum4.visible = true
	if max_lives >= 5:
		rum5.visible = true
	if max_lives == 6:
		rum6.visible = true

func life_lost(lives):
	var lives_left = lives + 1
	if lives_left == 1:
		rum.set_texture(empty_rum)
	elif lives_left == 2:
		rum2.set_texture(empty_rum)
	elif lives_left == 3:
		rum3.set_texture(empty_rum)
	elif lives_left == 4:
		rum4.set_texture(empty_rum)
	elif lives_left == 5:
		rum5.set_texture(empty_rum)
	elif lives_left == 6:
		rum6.set_texture(empty_rum)
		
func lives_gained(lives):
	var lives_gained = lives
	if lives_gained >= 1:
		rum.set_texture(full_rum)
	if lives_gained >= 2:
		rum2.set_texture(full_rum)
	if lives_gained >= 3:
		rum3.set_texture(full_rum)
	if lives_gained >= 4:
		rum4.set_texture(full_rum)
	if lives_gained >= 5:
		rum5.set_texture(full_rum)
	if lives_gained == 6:
		rum6.set_texture(full_rum)
		
func set_coin_counter(player_coin_count):
	coin_count.text = str(player_coin_count)

func set_combo_count(num):
	comboCounter.text = str(num)
	combo_animation = true
	combo_label_size = 2
	combo_alpha = 0
	combo.visible = true

func set_combo_visibility(visibility):
	combo.visible = visibility

func set_level_timer(time):
	levelTimer.text = "TIME " + str(int(time))

func set_timer_visibility(visibility):
	levelTimer.visible = visibility
