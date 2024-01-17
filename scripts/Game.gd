extends Node2D

var levels = [preload("res://scenes/level_1.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready():
	var currentLevel = levels[0].instantiate()
	add_child(currentLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
