extends Area2D



func _on_body_entered(body):
	if(body.is_in_group("Player")):
		if GlobalValues.next_level != null:
			GlobalValues.level_index += 1
		else:
			pass
			#this will be the credits
