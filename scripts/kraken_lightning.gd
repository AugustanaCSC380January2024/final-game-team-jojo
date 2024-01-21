extends Area2D

func _ready():
	set_monitoring(false)
	await get_tree().create_timer(1).timeout
	set_monitoring(true)
	await get_tree().create_timer(1).timeout
	queue_free()
	


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt()
