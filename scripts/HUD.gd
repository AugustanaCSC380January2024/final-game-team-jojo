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

func _ready():
	rum4.visible = false
	rum5.visible = false
	rum6.visible = false

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
	
