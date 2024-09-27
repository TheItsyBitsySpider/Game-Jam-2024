class_name BaseCard

extends Node2D

var sprite: Sprite2D
var area: Area2D
var collision_shape: CollisionShape2D

var data: Dictionary

var moniker: String:
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
	
	area = get_node("Area2D")
	area.connect("input_event", _on_input_event)
	
	collision_shape = get_node("Area2D/CollisionShape2D")
	collision_shape.shape.extents.x = sprite.texture.get_width() / 2
	collision_shape.shape.extents.y = sprite.texture.get_height() / 2

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	# Could process other mouse events, such as when hovering over the card
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			play()

func play():
	print("Nothing")
