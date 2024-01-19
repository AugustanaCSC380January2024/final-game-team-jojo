extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var coin_noise = $coin_sound

var is_collectable = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if is_collectable:
			body.add_coin()
			coin_noise.play()
		is_collectable = false
		animated_sprite.play("coin_collected")
		await get_tree().create_timer(0.5).timeout
		queue_free()
