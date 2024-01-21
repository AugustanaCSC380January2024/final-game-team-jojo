extends Node2D

var levels = [preload("res://scenes/level_1.tscn"), preload("res://scenes/level_2.tscn")]
@onready var game_player = $Player
@onready var current_index = 0
@onready var current_level = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalValues.player = game_player
	current_index = GlobalValues.level_index
	current_level = levels[GlobalValues.level_index].instantiate()
	add_child(current_level)
	#current_level = currentLevel

func change_level():
	current_level.queue_free()
	current_level = levels[GlobalValues.level_index].instantiate()
	add_child(current_level)
	#current_level = currentLevel
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalValues.level_index != current_index:
		change_level()
		current_index = GlobalValues.level_index
