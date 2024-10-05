class_name Battle

extends Node2D

const SCENE: PackedScene = preload("res://scenes/battle.tscn")

const LABEL_TRANSITION_SPEED: int = 1
const LABEL_DEFAULT_COLOR: Vector3 = Vector3(1, 1, 1)
const LABEL_ACTIVE_COLOR: Vector3 = Vector3(0.702, 0.545, 0.169)

@onready var deck_label: RichTextLabel = %DeckSize
@onready var discard_label: RichTextLabel = %DiscardPileSize
@onready var energy_label: RichTextLabel = %Energy
@onready var end_turn_button: Button = %EndTurn

var deck: Array[BaseCard]
var discard: Array[BaseCard]

var turn_order: Array[Node2D]
var turn: int

var post_dialogue: String

var deck_label_color: Vector3 = LABEL_DEFAULT_COLOR
var deck_label_target_color: Vector3 = LABEL_DEFAULT_COLOR

var discard_label_color: Vector3 = LABEL_DEFAULT_COLOR
var discard_label_target_color: Vector3 = LABEL_DEFAULT_COLOR

func _init():
	_shuffle_deck(Player.deck)

func _shuffle_deck(deck_to_pick_from: Array[BaseCard]):
	var picked = []
	for i in range(len(deck_to_pick_from)):
		picked.append(false)
	
	for i in range(len(deck_to_pick_from)):
		var pick = randi_range(0, len(deck_to_pick_from) - 1)
		while picked[pick]:
			pick = (pick + 1) % len(deck_to_pick_from)
		deck.append(deck_to_pick_from[pick])
		picked[pick] = true

func _ready():
	_update_deck_label()
	_update_discard_label()
	
	turn_order.front().ping()

func _process(delta: float):
	var speed = LABEL_TRANSITION_SPEED * delta
	
	var num_unplayable = 0
	for card in Player.hand.cards:
		if card.cost > Main.puppet.current_energy:
			num_unplayable += 1
	
	var font_colors = [
		"font_disabled_color",
		"font_hover_pressed_color",
		"font_hover_color",
		"font_pressed_color",
		"font_focus_color",
		"font_color"]
	
	if num_unplayable == len(Player.hand.cards):
		var color = Battle.LABEL_ACTIVE_COLOR
		color = Color(color.x, color.y, color.z)
		for font_color in font_colors:
			end_turn_button.add_theme_color_override(font_color, color)
	else:
		for font_color in font_colors:
			end_turn_button.remove_theme_color_override(font_color)
	
	deck_label_color = lerp(deck_label_color, deck_label_target_color, speed)
	discard_label_color = lerp(discard_label_color, discard_label_target_color,
							   speed)
	
	deck_label.add_theme_color_override("default_color", Color(
		deck_label_color.x, deck_label_color.y, deck_label_color.z))
	discard_label.add_theme_color_override("default_color", Color(
		discard_label_color.x, discard_label_color.y, discard_label_color.z))

func _on_end_turn_button_pressed():
	next_turn()

func next_turn():
	turn = (turn + 1) % len(turn_order)
	turn_order[turn].ping()

func erase_combatant(character: Node2D):
	turn_order.erase(character)
	if turn_order.size() == 1:
		Main.act.end_battle()

func _update_deck_label():
	deck_label.text = str(len(deck))

func _update_discard_label():
	discard_label.text = str(len(discard))

func update_energy_label(current: int, total: int):
	energy_label.text = ''.join(["", current, "/", total])

func pop_deck() -> BaseCard:
	if not deck:
		_shuffle_deck(discard)
		discard = []
		_update_discard_label()
	
	var card = deck.pop_back()
	_update_deck_label()
	
	deck_label_color = LABEL_ACTIVE_COLOR
	deck_label.add_theme_color_override("default_color", Color(
		LABEL_ACTIVE_COLOR.x, LABEL_ACTIVE_COLOR.y, LABEL_ACTIVE_COLOR.z))
	
	return card

func discard_card(card: BaseCard):
	discard.append(card)
	_update_discard_label()
	
	discard_label_color = LABEL_ACTIVE_COLOR
	discard_label.add_theme_color_override("default_color", Color(
		LABEL_ACTIVE_COLOR.x, LABEL_ACTIVE_COLOR.y, LABEL_ACTIVE_COLOR.z))
