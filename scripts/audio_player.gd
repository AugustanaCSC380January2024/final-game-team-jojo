extends Node
	
@onready var level1 = preload("res://assets/music/Avast!.mp3")
@onready var level2 = preload("res://assets/music/Hold Your Breath.mp3")
@onready var level3 = preload("res://assets/music/A Nice Neighborhood.mp3")
@onready var level1SFX = preload("res://assets/sounds/ocean-waves.mp3")
@onready var level2SFX = preload("res://assets/sounds/underwater-ambience.mp3")
@onready var level3SFX = preload("res://assets/sounds/storm-thunder-rain-wind.mp3")
@onready var shop = preload("res://assets/music/Is This a Sustainable Business Model.mp3")
@onready var boss = preload("res://assets/music/Uh Oh! This One Is Stronger.mp3")
@onready var combo = preload("res://assets/music/metal-dark-matter-111451.mp3")
@onready var ASP = null
@onready var SFX = null

func _ready():
	ASP = AudioStreamPlayer.new()
	SFX = AudioStreamPlayer.new()
	add_child(ASP)
	add_child(SFX)

func play():
	ASP.play()
	SFX.play()

func stop():
	ASP.stop()

func restart():
	ASP.stop()
	SFX.stop()
	ASP.play()
	SFX.play()
	
func change_music(music_name, sfx_name):
	var stream1 = null
	var stream2 = null
	if music_name == "level1":
		stream1 = level1
	elif music_name == "level2":
		stream1 = level2
	elif music_name == "level3":
		stream1 = level3
	elif music_name == "shop":
		stream1 = shop
	elif music_name == "boss":
		stream1 = boss
	elif music_name == "combo_music":
		stream1 = combo
	if sfx_name == "level1":
		stream2 = level1SFX
	elif sfx_name == "level2":
		stream2 = level2SFX
	elif sfx_name == "level3":
		stream2 = level3SFX
	
	if stream1 != null:
		ASP.stream = stream1
		ASP.play()
	else:
		ASP.stop()
	if SFX.stream != stream2:
		if stream2 != null:
			SFX.stream = stream2
			SFX.play()
		else:
			SFX.stop()
