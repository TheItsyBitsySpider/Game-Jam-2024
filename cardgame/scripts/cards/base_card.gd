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
var target_rotation_degrees: float

var rotation_degrees_before_dragging: float

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
	rotation_degrees = lerp(rotation_degrees, target_rotation_degrees,
							speed / 2)
	
	if not Player.dragged_card:
		if Player.hovered_cards:
			var hovered_card = Player.hovered_cards.front()
			for card in Player.hovered_cards:
				if card.position.x > hovered_card.position.x:
					hovered_card = card
			
			if hovered_card == self:
				if Input.is_action_pressed("left_click"):
					if not Player.smother_left_click:
						rotation_degrees_before_dragging = target_rotation_degrees
						target_rotation_degrees = 0
						rotation_degrees = 0
						sprite.rotation_degrees = 0
						Player.smother_left_click = true
						Player.dragged_card = self
						return
				
				var screen_size = get_viewport().content_scale_size
				var hand_position = screen_size.y / 2 - BaseCard.HEIGHT / 2.25
				var difference = hand_position - position.y
				sprite_target_position.x = 0
				sprite_target_position.y = difference - HEIGHT / 4
				sprite.rotation_degrees = -rotation_degrees
				
				z_index = 1
				
				return
		
		sprite_target_position.x = 0
		sprite_target_position.y = 0
		sprite.rotation_degrees = 0
		
		z_index = 0

func play(_character: Node2D) -> bool:
	var puppet = Main.battle.puppet
	if cost <= puppet.current_energy:
		puppet.current_energy -= cost
		Player.discard_card(self)
		return true
	return false
