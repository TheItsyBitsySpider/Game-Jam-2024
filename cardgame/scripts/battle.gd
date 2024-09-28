class_name Battle

extends Node2D

const SCENE: PackedScene = preload("res://scenes/battle.tscn")

@onready var deck_label: RichTextLabel = %DeckSize
@onready var discard_label: RichTextLabel = %DiscardPileSize
@onready var energy_label: RichTextLabel = %Energy

var deck: Array[BaseCard]
var discard: Array[BaseCard]

var turn_order: Array
var turn: int

func _init():
	_shuffle_deck()

func _shuffle_deck():
	var picked = []
	for i in range(len(Player.deck)):
		picked.append(false)
	
	for i in range(len(Player.deck)):
		var pick = randi_range(0, len(Player.deck) - 1)
		while picked[pick]:
			pick = (pick + 1) % len(Player.deck)
		deck.append(Player.deck[pick])
		picked[pick] = true

func _ready():
	_update_deck_label()
	_update_discard_label()
	
	var characters = [Puppet.SCENE.instantiate(), Enemy.SCENE.instantiate()]
	for character in characters:
		turn_order.append(character)
		add_child(character)
	turn_order.front().ping()

func next_turn():
	turn = (turn + 1) % len(turn_order)
	turn_order[turn].ping()

func _update_deck_label():
	deck_label.text = ' '.join(["Deck:", len(deck)])

func _update_discard_label():
	discard_label.text = ' '.join(["Discard:", len(discard)])

func update_energy_label(current: int, total: int):
	energy_label.text = ' '.join(["Energy:", current, "/", total])

func pop_deck():
	deck.pop_back()
	_update_deck_label()
	if not deck:
		pass
