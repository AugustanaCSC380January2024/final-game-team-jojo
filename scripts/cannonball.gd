extends Area2D

@onready var cannonball  = $Sprite2D
@onready var flight_path = $Path2D
@export var cannon_speed = 300
var player_location = null
var exploded = false
var angle = 0
var parried = false

func _ready():
	player_location = GlobalValues.playerPosition
	var deltaDistance = player_location - global_position
	angle = atan2(deltaDistance.y, deltaDistance.x)
	print((angle/(2 * PI)) * 360)

func _process(delta):
	if !parried:
		global_position.x += cos(angle) * cannon_speed * delta
		global_position.y += sin(angle) * cannon_speed * delta
	elif parried:
		global_position.y += -2000 * delta

func _on_body_entered(body):
	if body.is_in_group("Player") && !exploded:
		body.hurt()
		queue_free()
