extends Node

@onready var playerPosition = Vector2.ZERO
@onready var player = null
@onready var spawnCoinLocation = null
@onready var spawnRumLocation = null
@onready var current_level = null
@onready var next_level = null
@onready var level_index = 0
@onready var extra_rum = 0
@onready var spring_leg = false
@onready var wheelboots = false
@onready var beans = false
@onready var extra_barrel = false
@onready var loudener = false
@onready var jolly_roger = false
@onready var infamy = 0
@onready var level_infamy = 0
#add a max infamy if we want, but maybe not lol
