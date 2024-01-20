extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var coin_noise = $coin_sound

var gravity_stength = 7
var is_collectable = true
var gravity_enabled = false
var fling_timer = 0
var rand_facing = 0
var rand_strength = 0

func _physics_process(delta):
	if gravity_enabled:
		global_position.y += gravity_stength
		print("coming down")
	if fling_timer > 0:
		print("going up")
		fling_timer -= delta
		global_position.y -= 13
		global_position.x += 2 * rand_facing * rand_strength

func fling_coin():
	gravity_enabled = true
	fling_timer = .2
	rand_facing = randf_range(-1,1)
	rand_strength = randf_range(1,1.5)
	

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
