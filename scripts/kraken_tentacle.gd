extends Area2D

@onready var animation  = $AnimatedSprite2D
@export var tentacle_speed = -300
var pushed = false

func _physics_process(delta):
	global_position.x += tentacle_speed*delta
	if pushed:
		GlobalValues.player.velocity.x = -5000

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt()
		pushed = true
		await get_tree().create_timer(1).timeout
		pushed = false
