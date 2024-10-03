class_name Main

extends Node2D

static var INSTANCE: Main

@onready var camera: Camera = $Camera2D

static var screen_size: Vector2:
	get:
		return INSTANCE.get_viewport().content_scale_size

static var act: Act

static var puppet: Puppet:
	get:
		return act.puppet if act else null

static var dialogue: Dialogue:
	get:
		return act.dialogue if act else null

static var battle: Battle:
	get:
		return act.battle if act else null

func _init():
	INSTANCE = self

func _ready():
	_load()
	
	Player.setup()
	
	act = Act.SCENE.instantiate()
	add_child(act)
	act.start_dialogue()

func _load():
	DialogueDatabase.load_dialogue()
	CardDatabase.load_cards()
	EnemyDatabase.load_enemies()

func _process(delta: float):
	Player.process(delta)
