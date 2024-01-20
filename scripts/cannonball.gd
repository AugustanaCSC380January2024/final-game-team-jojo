extends Area2D

@onready var cannonball  = $Sprite2D
@onready var flight_path = $Path2D
@export var cannon_speed = -300
var player_location = null
var exploded = false

func _on_ready():
	player_location = GlobalValues.playerPosition

func _physics_process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Player") && !exploded:
		body.hurt()
		queue_free()
