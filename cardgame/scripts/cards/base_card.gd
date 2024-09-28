class_name BaseCard

extends Node2D

const SPEED: int = 8

const WIDTH: int = 136
const HEIGHT: int = 175

var sprite: Sprite2D
var area: Area2D
var collision_shape: CollisionShape2D

var data: Dictionary

var alias: String:
	get:
		return data["name"]

var cost: int:
	get:
		return data["cost"]

var texture: Resource:
	get:
		return data["texture"]

var target_position: Vector2
var sprite_target_position: Vector2

func setup(data: Dictionary):
	self.data = data
	
	sprite = get_node("Sprite2D")
	sprite.texture = texture
	sprite.scale *= min(float(WIDTH) / sprite.texture.get_width(),
						float(HEIGHT) / sprite.texture.get_height())
	
	area = get_node("Area2D")
	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)
	
	collision_shape = get_node("Area2D/CollisionShape2D")
	collision_shape.shape.extents.x = WIDTH / 2
	collision_shape.shape.extents.y = HEIGHT / 2

func _on_mouse_entered():
	Player.hovered_cards.append(self)

func _on_mouse_exited():
	Player.hovered_cards.erase(self)

func _process(delta: float):
	var speed = SPEED * delta
	position = lerp(position, target_position, speed)
	sprite.position = lerp(sprite.position, sprite_target_position, speed)
	
	if Player.hovered_cards and Player.hovered_cards.front() == self:
		if Input.is_action_just_pressed("left_click"):
			if not Player.smother_left_click:
				Player.smother_left_click = true
				play()
		
		var screen_size = get_viewport().content_scale_size
		var hand_position = screen_size.y / 2 - BaseCard.HEIGHT / 2.25
		var difference = hand_position - position.y
		sprite_target_position.y = difference - HEIGHT / 4
		sprite.rotation_degrees = -rotation_degrees
	else:
		sprite_target_position.y = 0
		sprite.rotation_degrees = 0

func play():
	Player.hand.erase(self)
	Player.hovered_cards.erase(self)
	queue_free()
