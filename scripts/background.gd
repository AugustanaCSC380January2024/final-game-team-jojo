extends ParallaxBackground

@onready var sky = $SkyLayer
@onready var ocean = $OceanLayer
@onready var sand = $SandLayer
var time = 0

func _process(delta):
	time += delta
	sand.motion_offset = Vector2(GlobalValues.playerPosition.x / 16, GlobalValues.playerPosition.y / 64)
	ocean.motion_offset = Vector2(GlobalValues.playerPosition.x / 4 - sin(time/3) * 60, GlobalValues.playerPosition.y / 16 + cos(time/4) * 15)
	sky.motion_offset = Vector2(GlobalValues.playerPosition.x / 2, GlobalValues.playerPosition.y / 8)
