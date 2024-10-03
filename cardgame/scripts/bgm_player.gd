class_name BGM_Player

extends AudioStreamPlayer2D

var fade_speed: float
var target_volume_db: float

func _process(delta: float):
	volume_db = lerp(volume_db, target_volume_db, fade_speed * delta)
