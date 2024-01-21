extends Node
	
@onready var level1 = preload("res://assets/music/Avast!.mp3")
@onready var level2 = preload("res://assets/music/Hold Your Breath.mp3")
@onready var level3 = preload("res://assets/music/A Nice Neighborhood.mp3")
@onready var shop = preload("res://assets/music/Is This a Sustainable Business Model.mp3")
@onready var boss = preload("res://assets/music/Uh Oh! This One Is Stronger.mp3")
@onready var musicPlayer = $AudioStreamPlaye2D

func change_music(sfx_name):
	if get_tree().get_first_node_in_group("SFX") != null:
		get_tree().get_first_node_in_group("SFX").queue_free()
	var stream = null
	if sfx_name == "level1":
		stream = level1
	elif sfx_name == "level2":
		stream = level2
	elif sfx_name == "level3":
		stream = level3
	elif sfx_name == "shop":
		stream = shop
	elif sfx_name == "boss":
		stream = boss
	
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "Music"
	
	asp.play()

func test():
	print("Test")
