class_name CardDatabase

const CARD_DIR_PATH = "res://data/cards/"

static var BASE_CARD = load("res://scenes/card.tscn")
static var cards : Dictionary

static func load_cards():
	cards = {}
	var all_card_jsons = DirAccess.open(CARD_DIR_PATH).get_files()
	for card_json in all_card_jsons:
		var loaded_file = FileAccess.open(CARD_DIR_PATH + card_json, FileAccess.READ)
		var card_info = JSON.parse_string(loaded_file.get_as_text())
		cards[card_info["name"]] = card_info
	print("Loaded " + str(len(cards)) + " cards into database.")

static func create_card(name):
	var card = BASE_CARD.instantiate()
	card.set_script(load(CardDatabase.cards[name]["ability"]))
	card.card_stats = CardDatabase.cards[name]
	card.card_setup()
	return card
