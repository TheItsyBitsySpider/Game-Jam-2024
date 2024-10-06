class_name Main

extends Node2D

const WORLD_BGM: Resource = preload("res://resources/soundtracks/world.wav")
const BATTLE_BGM: Resource = preload("res://resources/soundtracks/battle.wav")
const BOSS_INTRO_BGM: Resource = preload("res://resources/soundtracks/BossIntro.wav")
const BOSS_BGM: Resource = preload("res://resources/soundtracks/BossTheme.wav")

static var INSTANCE: Main

@onready var _camera: Camera = $Camera2D
@onready var _world_bgm_player: BGM_Player = %WorldBGMPlayer
@onready var _battle_bgm_player: BGM_Player = %BattleBGMPlayer
@onready var _puppet: Puppet = $Puppet

static var camera: Camera2D:
	get:
		return INSTANCE._camera

static var world_bgm_player: BGM_Player:
	get:
		return INSTANCE._world_bgm_player

static var battle_bgm_player: BGM_Player:
	get:
		return INSTANCE._battle_bgm_player

static var puppet: Puppet:
	get:
		return INSTANCE._puppet

static var screen_size: Vector2:
	get:
		return INSTANCE.get_viewport().content_scale_size

static var act: Act

static var dialogue: Dialogue:
	get:
		return act.dialogue if act else null

static var battle: Battle:
	get:
		return act.battle if act else null

static var in_transition: bool = false

func _init():
	INSTANCE = self

func _ready():
	_load()
	
	Player.setup()
	
	act = ActDatabase.create_act()
	add_child(act)
	
	puppet.reparent(act)
	
	world_bgm_player.play()
	battle_bgm_player.play()
	world_bgm_player.reparent(puppet)
	battle_bgm_player.reparent(puppet)
	battle_bgm_player.target_volume_db = -80

func _load():
	ActDatabase.load_acts()
	DialogueDatabase.load_dialogue()
	CardDatabase.load_cards()
	EnemyDatabase.load_enemies()

func _process(delta: float):
	Player.process(delta)

func _on_world_bgm_player_finished() -> void:
	world_bgm_player.play()

func _on_battle_bgm_player_finished():
	battle_bgm_player.play()

static func next_act(_args: Dictionary):
	in_transition = true
	
	var index = act.index + 1
	act.queue_free()
	act = ActDatabase.create_act(index)
	INSTANCE.add_child(act)
	puppet.reparent(act)
	
	in_transition = false
