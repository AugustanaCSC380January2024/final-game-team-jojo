extends Area2D

@onready var hitbox_shape = $CollisionShape2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.hurt_i_frames <= 0:
			body.hurt()
