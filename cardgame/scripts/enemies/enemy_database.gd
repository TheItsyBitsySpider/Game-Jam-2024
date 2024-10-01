class_name EnemyDatabase

const DIR_PATH: String = "res://resources/enemies/data/"

static var data: Dictionary

static func load_enemies():
	data = {}
	var file_names = DirAccess.open(DIR_PATH).get_files()
	for file_name in file_names:
		var file = FileAccess.open(DIR_PATH + file_name, FileAccess.READ)
		var json = JSON.parse_string(file.get_as_text())
		var name = json["name"]
		data[name] = json
		data[name]["texture"] = load(data[name]["texture"])
	print("Loaded " + str(len(data)) + " enemies.")

static func create_enemy(name) -> Enemy:
	var enemy = Enemy.SCENE.instantiate()
	enemy.data = data[name]
	return enemy
