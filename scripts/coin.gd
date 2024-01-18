extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var coin_noise = $coin_sound

var is_collectable = true

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if is_collectable:
			body.coin_count += 1
			coin_noise.play()
		is_collectable = false
		print(body.coin_count)
		animated_sprite.play("coin_collected")
		await get_tree().create_timer(1.2).timeout
		queue_free()
