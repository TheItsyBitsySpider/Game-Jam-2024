class_name ActDatabase

const ACT_DIR_PATH: String = "res://resources/acts/data/"

static var act_database: Dictionary
#static var post_combat_dialogue: Array[String]
#static var combat_triggers: Array[Trigger]

static func load_act_information():
	var file_names = DirAccess.open(ACT_DIR_PATH).get_files()
	
	for file_name in file_names:
		var file_path = ACT_DIR_PATH + file_name
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		var act_number = int(json["act"])
		act_database[act_number] = json
		act_database[act_number]["background"] = load(act_database[act_number]["background"])
	print("Loaded " + str(len(act_database)) + " acts.")
