extends Node
	
@onready var level1 = preload("res://assets/music/Avast!.mp3")
@onready var level2 = preload("res://assets/music/Hold Your Breath.mp3")
@onready var level3 = preload("res://assets/music/A Nice Neighborhood.mp3")
@onready var shop = preload("res://assets/music/Is This a Sustainable Business Model.mp3")
@onready var boss = preload("res://assets/music/Uh Oh! This One Is Stronger.mp3")
@onready var ASP = null

func _ready():
	ASP = AudioStreamPlayer.new()
	add_child(ASP)

func play():
	ASP.play()

func stop():
	ASP.stop()

func restart():
	ASP.stop()
	ASP.play()
	
func change_music(sfx_name):
	#if ASP.is_playing():
		#ASP.stop()
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
	
	ASP.stream = stream
	ASP.play()
