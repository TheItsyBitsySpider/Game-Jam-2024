class_name Main

extends Node2D

const WORLD_BGM: Resource = preload("res://resources/soundtracks/world.wav")
const BATTLE_BGM: Resource = preload("res://resources/soundtracks/battle.wav")

static var INSTANCE: Main

@onready var camera: Camera = $Camera2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

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
	
	audio_stream_player.reparent(act.puppet)

func _load():
	DialogueDatabase.load_dialogue()
	CardDatabase.load_cards()
	EnemyDatabase.load_enemies()

func _process(delta: float):
	Player.process(delta)

func _on_audio_stream_player_finished():
	audio_stream_player.play()
