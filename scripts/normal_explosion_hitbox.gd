extends Area2D

@onready var hitbox_shape = $CollisionShape2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt()
	elif body.is_in_group("enemy") && !body.is_in_group("boss"):
		if !body.is_exploding:
			body.queue_free()
