class_name DialogueDatabase

const CHARACTER_DIR_PATH: String = "res://resources/dialogue/data/characters/"
const SCENE_DIR_PATH: String = "res://resources/dialogue/data/scenes/"

static var character_data: Dictionary
static var scene_data: Dictionary

static func load_dialogue():
	character_data = {}
	var file_names = DirAccess.open(CHARACTER_DIR_PATH).get_files()
	for file_name in file_names:
		var file_path = CHARACTER_DIR_PATH + file_name
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		var name = json["name"]
		character_data[name] = json
		var params = ["texture", "font_style"]
		for param in params:
			character_data[name][param] = load(character_data[name][param])
	print("Loaded " + str(len(character_data)) + " characters.")
	
	scene_data = {}
	file_names = DirAccess.open(SCENE_DIR_PATH).get_files()
	for file_name in file_names:
		var file_path = SCENE_DIR_PATH + file_name
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		var name = file_name.trim_suffix(".json")
		scene_data[name] = json
	print("Loaded " + str(len(scene_data)) + " scenes.")

static func create_dialogue(name: String) -> Dialogue:
	var dialogue = Dialogue.SCENE.instantiate()
	dialogue.data = scene_data[name]
	return dialogue
