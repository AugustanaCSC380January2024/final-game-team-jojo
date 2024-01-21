extends ParallaxBackground

@onready var surface = $ocean_surface
@onready var ocean = $ocean_normal
@onready var depths = $ocean_deep
@onready var abyss = $ocean_abyss
var time = 0

func _process(delta):
	time += delta
	surface.motion_offset = Vector2(GlobalValues.playerPosition.x / 16, GlobalValues.playerPosition.y / 64)
	ocean.motion_offset = Vector2(GlobalValues.playerPosition.x / 8 - sin(time/3) * 60, GlobalValues.playerPosition.y / 16 + cos(time/4) * 15)
	depths.motion_offset = Vector2(GlobalValues.playerPosition.x / 8 - sin(time/3) * 60, GlobalValues.playerPosition.y / 16 + cos(time/4) * 15)
	abyss.motion_offset = Vector2(GlobalValues.playerPosition.x / 8 - sin(time/3) * 60, GlobalValues.playerPosition.y / 16 + cos(time/4) * 15)
