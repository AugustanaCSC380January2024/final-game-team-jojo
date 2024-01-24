extends Node2D

var levels = [preload("res://scenes/level_1.tscn"), preload("res://scenes/shop.tscn"), preload("res://scenes/level_2.tscn"), preload("res://scenes/shop.tscn"), preload("res://scenes/level_3.tscn"), preload("res://scenes/credits.tscn")]
@onready var game_player = $Player
@onready var fullscreen = false
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
	if Input.is_action_just_pressed("fullscreen"):
		if fullscreen:
			set_windowed()
		else:
			set_fullscreen()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if GlobalValues.level_index != current_index:
		change_level()
		current_index = GlobalValues.level_index

func set_fullscreen():
	if !fullscreen:
		#window.boarderless = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = true
		print("Fullscreen")

func set_windowed():
	if fullscreen:
		#window.boarderless = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = false
		print("Windowed")
