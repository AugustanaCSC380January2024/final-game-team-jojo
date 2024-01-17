extends CharacterBody2D

@onready var hitbox = preload("res://scenes/hitbox.tscn")
@onready var animated_sprite = $AnimatedSprite2D
var following = false

func _physics_process(delta):
	if following:
		

func attack():
	animated_sprite.play("attack")
	await get_tree().create_timer(.3).timeout
	var attack_hitbox = hitbox.instantiate()
	add_child(attack_hitbox)
	await get_tree().create_timer(.3).timeout
	attack_hitbox.queue_free()


func _on_sight_radius_body_entered(body):
	if body is Player:
		follow = true
