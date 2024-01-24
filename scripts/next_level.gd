extends Area2D

func next_level():
	#if GlobalValues.next_level != null: #Does this fix level change issue?
	GlobalValues.level_index += 1
	GlobalValues.infamy = GlobalValues.infamy + GlobalValues.level_infamy
	GlobalValues.level_infamy = 0

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		next_level()
	else:
		pass
		#this will be the credits
