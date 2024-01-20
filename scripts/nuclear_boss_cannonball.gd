extends Area2D

@onready var animation = $AnimatedSprite2D
@onready var explosion_sfx = $AudioStreamPlayer2D
@onready var explosion_hitbox = preload("res://scenes/nuclear_explosion_hitbox.tscn")
var bomb_timer = 5
var speed = 1

func _physics_process(delta):
	global_position.x -= speed
	if bomb_timer != null:
		if bomb_timer > 0:
			bomb_timer -= delta
		else: nuke()
	
func nuke():
	bomb_timer = null
	speed = 0
	animation.play("nuke")
	explosion_sfx.play()
	var attack_hitbox = explosion_hitbox.instantiate()
	add_child(attack_hitbox)
	await get_tree().create_timer(2).timeout
	attack_hitbox.queue_free()
	queue_free()
