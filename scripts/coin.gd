extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var coin_noise = $coin_sound

var is_collectable = true
var gravity_enabled = false
var gravity_strength = 980
var velocity = Vector2.ZERO
var power = 0
var angle = PI/2

func _physics_process(delta):
	if gravity_enabled:
		global_position.x += velocity.x * delta
		global_position.y += velocity.y * delta
		velocity.y += gravity_strength * delta

func fling_coin():
	gravity_enabled = true
	angle = randf_range(PI/3, 2 * PI/3)
	power = randf_range(400, 600)
	velocity = Vector2(cos(angle) * power, -sin(angle) * power)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if is_collectable:
			body.add_coin()
			coin_noise.play()
		is_collectable = false
		animated_sprite.play("coin_collected")
		await get_tree().create_timer(0.5).timeout
		queue_free()
	else:
		gravity_enabled = false
