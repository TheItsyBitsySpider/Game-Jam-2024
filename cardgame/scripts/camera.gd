class_name Camera

extends Camera2D

const SPEED: int = 2

var target_position: Vector2

func _process(delta: float):
	var speed = SPEED * delta
	position = lerp(position, target_position, speed)
