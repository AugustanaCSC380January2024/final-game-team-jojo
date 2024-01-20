extends Node2D

var levels = [preload("res://scenes/level_1.tscn")]
@onready var game_player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	var currentLevel = levels[0].instantiate()
	add_child(currentLevel)
	GlobalValues.player = game_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
