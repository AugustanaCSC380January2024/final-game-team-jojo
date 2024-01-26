extends Node2D

@onready var image = $CanvasLayer2/TextureRect
@onready var level_change = $next_level
var images = [load("res://assets/story/story_2.png"), load("res://assets/story/story_3.png"), load("res://assets/story/story_4.png"), load("res://assets/story/story_5.png")]
var current_image_index = -1

func _ready():
	GlobalValues.player.hud.visible = false
	GlobalValues.player.attack_timer = 999999

func _on_button_pressed():
	current_image_index += 1
	if current_image_index == 4:
		GlobalValues.player.hud.visible = true
		GlobalValues.player.attack_timer = 0
		level_change.next_level()
	else:
		image.set_texture(images[current_image_index])
