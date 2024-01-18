extends Area2D

var player_facing = 1
var y_change = 0

func send_facing(current_facing):
	player_facing = current_facing

func set_change_y(y_amount):
	y_change = y_amount

func _physics_process(delta):
	global_position.x += 20 * player_facing
	global_position.y += y_change


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.queue_free()
	queue_free()
