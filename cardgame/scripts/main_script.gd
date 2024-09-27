extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	CardDatabase.load_cards()
	var test_card_to_add = CardDatabase.create_card("TestCard")
	add_child(test_card_to_add)
