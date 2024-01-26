extends Node2D

@onready var image = $CanvasLayer/TextureRect
@onready var credits = load("res://assets/credits.png")
@onready var level_change = $next_level

func _ready():
	GlobalValues.player.hud.visible = false
	GlobalValues.player.attack_timer = 999999
	AudioPlayer.change_music("None", "level1")

func _on_button_pressed():
	if image.get_texture() == credits:
		GlobalValues.level_index = 0
		level_change.next_level()
	image.set_texture(credits)
