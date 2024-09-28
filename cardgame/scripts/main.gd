class_name Main

extends Node2D

static var INSTANCE: Main

static var battle: Battle

func _init():
	INSTANCE = self

func _ready():
	_load()
	
	Player.setup()
	
	battle = Battle.SCENE.instantiate() as Battle
	add_child(battle)

func _load():
	CardDatabase.load_cards()

func _process(delta: float):
	Player.process(delta)
