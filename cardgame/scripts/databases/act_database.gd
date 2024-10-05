class_name ActDatabase

const DIR_PATH: String = "res://resources/acts/data/"
const SCENE: PackedScene = preload("res://scenes/act.tscn")

static var data: Dictionary

static func load_acts():
	var file_names = DirAccess.open(DIR_PATH).get_files()
	
	for file_name in file_names:
		var file_path = DIR_PATH + file_name
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		var index = int(json["index"])
		data[index] = json
		data[index]["background"] = load(data[index]["background"])
		for object in data[index]["objects"]:
			object["texture"] = load(object["texture"])
	print("Loaded " + str(len(data)) + " acts.")

static func create_act(index: int = 0) -> Act:
	var act = SCENE.instantiate() as Act
	act.data = data[index]
	return act
