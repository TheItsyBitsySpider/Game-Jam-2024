extends Node2D

func _ready():
	_load()
	
	var card = CardDatabase.create_card("test_card_1")
	add_child(card)

func _load():
	CardDatabase.load_cards()
