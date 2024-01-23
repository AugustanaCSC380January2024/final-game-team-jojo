extends Area2D

@onready var animation  = $AnimatedSprite2D
@export var bomb_speed = -300
var exploded = false
var direction = 1

func aim(currentLocation):
	if GlobalValues.playerPosition.x < currentLocation.x:
		direction = 1
	else:
		direction = -1

func _physics_process(delta):
	global_position.x += bomb_speed*delta * direction


func _on_body_entered(body):
	if body.is_in_group("Player") && !exploded:
		body.hurt()
		exploded = true
		animation.play("exploding_bomb")
		bomb_speed = 0
		await get_tree().create_timer(1).timeout
		queue_free()
	elif !exploded:
		exploded = true
		animation.play("exploding_bomb")
		bomb_speed = 0
		await get_tree().create_timer(1).timeout
		queue_free()
