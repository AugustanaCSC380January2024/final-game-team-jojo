extends Node2D

@onready var image = $CanvasLayer/TextureRect
@onready var credits = load("res://assets/credits.png")

func _ready():
	GlobalValues.player.hud.visible = false

func _on_button_pressed():
	image.set_texture(credits)
