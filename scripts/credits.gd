extends Node2D

@onready var image = $CanvasLayer/TextureRect
@onready var credits = load("res://assets/credits.png")

func _ready():
	GlobalValues.player.hud.visible = false
	GlobalValues.player.attack_timer = 999999

func _on_button_pressed():
	image.set_texture(credits)
