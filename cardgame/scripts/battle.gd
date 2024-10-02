class_name Battle

extends Node2D

const SCENE: PackedScene = preload("res://scenes/battle.tscn")

@onready var deck_label: RichTextLabel = %DeckSize
@onready var discard_label: RichTextLabel = %DiscardPileSize
@onready var energy_label: RichTextLabel = %Energy
@onready var end_turn_button: Button = %EndTurn

var deck: Array[BaseCard]
var discard: Array[BaseCard]

var turn_order: Array[Node2D]
var turn: int

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
	
	var enemy_types = ["Wyrmknight", "Thornpawn", "Abysshop"]
	var enemy = EnemyDatabase.create_enemy(enemy_types.pick_random())
	enemy.position.x = Main.puppet.position.x + Main.screen_size.x / 2
	
	var characters = [enemy]
	for character in characters:
		turn_order.append(character)
		add_child(character)
	
	turn_order.push_front(Main.act.puppet)
	turn_order.front().ping()

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
	deck_label.text = ' '.join(["Deck:", len(deck)])

func _update_discard_label():
	discard_label.text = ' '.join(["Discard:", len(discard)])

func update_energy_label(current: int, total: int):
	energy_label.text = ' '.join(["Energy:", current, "/", total])

func pop_deck() -> BaseCard:
	if not deck:
		_shuffle_deck(discard)
		discard = []
		_update_discard_label()
	
	var card = deck.pop_back()
	_update_deck_label()
	return card

func discard_card(card: BaseCard):
	discard.append(card)
	_update_discard_label()
