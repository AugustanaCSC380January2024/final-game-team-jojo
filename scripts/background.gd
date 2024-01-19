extends ParallaxBackground

@onready var sky = $SkyLayer
@onready var ocean = $OceanLayer
@onready var sand = $SandLayer

func _process(delta):
	sand.motion_offset = Vector2(GlobalValues.playerPosition.x / 16, GlobalValues.playerPosition.y / 64)
	ocean.motion_offset = Vector2(GlobalValues.playerPosition.x / 4, GlobalValues.playerPosition.y / 16)
	sky.motion_offset = Vector2(GlobalValues.playerPosition.x / 2, GlobalValues.playerPosition.y / 8)
