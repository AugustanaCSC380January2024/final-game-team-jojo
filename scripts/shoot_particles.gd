extends GPUParticles2D

func face_shot(shot, direction):
	if direction == -1 or 0:
		shot.position = Vector2(-29, 9)
		shot.scale = Vector2(-1,1)
		print(shot.position)
