extends Area2D

@onready var animation  = $AnimatedSprite2D
@export var bomb_speed = -300
var exploded = false
var direction = 1
var parried = false
var can_explode_timer = .2

func aim(currentLocation):
	if GlobalValues.playerPosition.x < currentLocation.x:
		direction = 1
	else:
		direction = -1

func _physics_process(delta):
	if can_explode_timer > 0:
		can_explode_timer -= delta
	if !parried:
		global_position.x += bomb_speed*delta * direction
	elif parried && !GlobalValues.sword:
		global_position.y += -2000 * delta
	elif parried && GlobalValues.sword:
		global_position.x += bomb_speed*delta * direction * -2

func _on_body_entered(body):
	if body.is_in_group("Player") && !exploded:
		body.hurt()
		exploded = true
		animation.play("exploding_bomb")
		bomb_speed = 0
		await get_tree().create_timer(1).timeout
		queue_free()
	elif body.is_in_group("enemy") && !exploded && GlobalValues.sword && parried:
		body.damage(1)
		exploded = true
		animation.play("exploding_bomb")
		bomb_speed = 0
		await get_tree().create_timer(1).timeout
		queue_free()
	elif !exploded && can_explode_timer <= 0:
		exploded = true
		animation.play("exploding_bomb")
		bomb_speed = 0
		await get_tree().create_timer(1).timeout
		queue_free()
