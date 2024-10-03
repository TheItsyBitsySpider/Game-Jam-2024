class_name Act

extends Node2D

const SCENE: PackedScene = preload("res://scenes/act.tscn")

const PUPPET_SPEED: int = 500

@onready var background: Sprite2D = %Background
@onready var puppet: Puppet = $Puppet

var dialogue: Dialogue
var in_dialogue: bool = false

var battle: Battle
var in_battle: bool = false

func _init():
	var trigger = Trigger.SCENE.instantiate()
	trigger.position.x = Main.screen_size.x / 4
	add_child(trigger)

func _process(delta: float):
	if not in_dialogue and not in_battle:
		var moving_right = Input.is_action_pressed("right")
		var moving_left = Input.is_action_pressed("left")
		
		if moving_right and moving_left:
			moving_right = false
			moving_left = false
		
		var speed = PUPPET_SPEED * delta
		
		if moving_right:
			puppet.position.x += speed
			Player.hand.position.x += speed
			Player.hand.target_position.x += speed
		elif moving_left:
			puppet.position.x -= speed
			Player.hand.position.x -= speed
			Player.hand.target_position.x -= speed
		
		var screen_size = Main.screen_size
		Main.camera.position.x = puppet.position.x + screen_size.x / 4
		Main.camera.target_position.x = Main.camera.position.x

func start_dialogue():
	in_dialogue = true
	dialogue = DialogueDatabase.create_dialogue("darling")
	add_child(dialogue)

func end_dialogue():
	in_dialogue = false
	dialogue.blackout_target_opacity = 0
	dialogue.canvas_layer.visible = false
	await dialogue.reached_blackout_target_opacity
	dialogue.queue_free()
	dialogue = null

func start_battle():
	in_battle = true
	
	Main.world_bgm_player.fade_speed = 0.1
	Main.battle_bgm_player.fade_speed = 3
	
	Main.world_bgm_player.target_volume_db = -80
	Main.battle_bgm_player.target_volume_db = 0
	
	Player.hand.pull_up()
	battle = Battle.SCENE.instantiate() as Battle
	add_child(battle)

func end_battle():
	in_battle = false
	
	Main.world_bgm_player.fade_speed = 3
	Main.battle_bgm_player.fade_speed = 0.1
	
	Main.world_bgm_player.target_volume_db = 0
	Main.battle_bgm_player.target_volume_db = -80
	
	Main.puppet.character.defense = 0
	Main.puppet.character.strength = 0
	Main.puppet.character.weak = 0
	Main.puppet.character.vulnerable = 0
	Main.puppet.character.phantasia = 0
	Player.hand.pull_down()
	battle.queue_free()
	battle = null
	await Player.hand.stabilized
	while Player.hand.cards:
		Player.hand.pop()
