extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

var is_collectable = true
var gravity_enabled = false
var gravity_strength = 980
var velocity = Vector2.ZERO
var power = 0
var angle = PI/2
var player_location = null
var attraction_timer = 3
var lifespan_timer = 10
var rum_speed = 600

func _physics_process(delta):
	player_location = GlobalValues.playerPosition
	var deltaDistance = player_location - global_position
	angle = atan2(deltaDistance.y, deltaDistance.x)
	if attraction_timer > 0:
		attraction_timer -= delta
	if lifespan_timer > 0:
		lifespan_timer -= delta
	if lifespan_timer <= 0:
		queue_free()
	if attraction_timer <= 0 && GlobalValues.player.lives != GlobalValues.player.max_lives:
		global_position.x += cos(angle) * rum_speed * delta
		global_position.y += sin(angle) * rum_speed * delta
	if gravity_enabled:
		global_position.x += velocity.x * delta
		global_position.y += velocity.y * delta
		velocity.y += gravity_strength * delta

func fling_rum():
	gravity_enabled = true
	angle = randf_range(PI/3, 2 * PI/3)
	power = randf_range(400, 600)
	velocity = Vector2(cos(angle) * power, -sin(angle) * power)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.lives != body.max_lives:
			if is_collectable:
				body.add_rum()
			is_collectable = false
			animated_sprite.play("picked_up")
			await get_tree().create_timer(0.5).timeout
			queue_free()
	else:
		gravity_enabled = false
