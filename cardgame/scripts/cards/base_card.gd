class_name BaseCard

extends Node2D

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

func setup(data: Dictionary):
	self.data = data
	
	sprite = get_node("Sprite2D")
	sprite.texture = texture
	sprite.scale *= min(float(WIDTH) / sprite.texture.get_width(),
						float(HEIGHT) / sprite.texture.get_height())
	
	area = get_node("Area2D")
	area.connect("input_event", _on_input_event)
	
	collision_shape = get_node("Area2D/CollisionShape2D")
	collision_shape.shape.extents.x = WIDTH / 2
	collision_shape.shape.extents.y = HEIGHT / 2

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	# Could process other mouse events, such as when hovering over the card
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			play()

func play():
	Player.hand.erase(self)
	queue_free()
