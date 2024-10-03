class_name CardDatabase

const DIR_PATH: String = "res://resources/cards/data/"
const SCENE: PackedScene = preload("res://scenes/card.tscn")

static var data: Dictionary

static func load_cards():
	data = {}
	var file_names = DirAccess.open(DIR_PATH).get_files()
	for file_name in file_names:
		var file = FileAccess.open(DIR_PATH + file_name, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		var name = json["name"]
		data[name] = json
		data[name]["texture"] = load(data[name]["texture"])
		data[name]["ability"] = load(data[name]["ability"])
	print("Loaded " + str(len(data)) + " cards.")

static func create_card(name: String) -> BaseCard:
	var card = SCENE.instantiate()
	card.set_script(data[name]["ability"])
	card.setup(data[name])
	return card
