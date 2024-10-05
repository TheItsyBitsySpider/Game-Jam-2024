class_name Hand

extends Node2D

const MAX_SIZE: int = 10
const SPEED: float = 4
const TARGET_DISTANCE: float = 10

var cards: Array[BaseCard]

var target_position: Vector2

var _interactable: bool = false
var interactable: bool:
	get:
		return _interactable
	set(val):
		Player.hovered_cards = []
		Player.dragged_card = null
		_interactable = val

signal stabilized

func _ready():
	position.y = Main.screen_size.y / 2 + BaseCard.HEIGHT / 2
	target_position.y = position.y

func _process(delta: float):
	var speed = SPEED * delta
	if position != target_position:
		position = lerp(position, target_position, speed)
		if position.distance_to(target_position) <= TARGET_DISTANCE:
			stabilized.emit()

func pull_up():
	interactable = true
	position.y = Main.screen_size.y / 2 - BaseCard.HEIGHT / 2.25
	target_position.y = position.y
	draw()

func pull_down():
	interactable = false
	target_position.y = Main.screen_size.y / 2 + BaseCard.HEIGHT / 2
	draw()

func add(card: BaseCard):
	if card and len(cards) < MAX_SIZE:
		add_child(card)
		card.position.x = 0
		card.global_position.y = 0
		card.target_position = card.position
		if card.cost <= Main.puppet.current_energy:
			card.modulate.a = 1
			card.target_opacity = 1
		else:
			card.modulate.a = 0.6
			card.target_opacity = 0.6
		cards.append(card)
		draw()

func erase(card: BaseCard):
	if card:
		remove_child(card)
		Player.hovered_cards.erase(card)
		if card == Player.dragged_card:
			Player.dragged_card = null
		cards.erase(card)
		draw()

func pop():
	if not cards.is_empty():
		erase(cards.back())
		draw()

func draw():
	var width = 0
	if not cards.is_empty():
		width = (len(cards) - 1) * BaseCard.WIDTH * 0.65 + BaseCard.WIDTH
	
	var start_position = BaseCard.WIDTH / 2 - width / 2
	
	var i = 0
	for card in cards:
		card.target_position.x = start_position + BaseCard.WIDTH * i * 0.65
		
		var middle = (len(cards) - 1) / 2.0
		var delta = i - middle
		card.target_rotation_degrees = delta * 5
		
		var alpha = deg_to_rad(abs(card.target_rotation_degrees))
		var dip = sin(alpha) * BaseCard.WIDTH
		card.target_position.y = pow(dip * 0.25, 1.75)
		
		i += 1
