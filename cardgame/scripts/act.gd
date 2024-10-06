class_name Act

extends Node2D

const SCENE: PackedScene = preload("res://scenes/act.tscn")

const PUPPET_SPEED: int = 800

@onready var background: Sprite2D = %Background

var data: Dictionary

var index: int:
	get:
		return data["index"]

var dialogue: Dialogue
var in_dialogue: bool = false

var battle: Battle
var in_battle: bool = false

func _ready():
	background.texture = data["background"]
	
	Main.puppet.position.x = 0
	
	Player.hand.position.x = Main.puppet.position.x + Main.screen_size.x / 4
	Player.hand.target_position.x = Player.hand.position.x
	
	Main.camera.position.x = Main.puppet.position.x + Main.screen_size.x / 4
	Main.camera.target_position.x = Main.camera.position.x
	
	for object in data["objects"]:
		var node = Sprite2D.new()
		node.texture = object["texture"]
		node.scale = Vector2(.5, .5)
		node.position.x = object["position"]
		node.flip_h = object["flip_h"]
		add_child(node)
	
	for trigger in data["triggers"]:
		var node = Trigger.SCENE.instantiate()
		node.position.x = trigger["position"]
		node.action = trigger["action"]
		node.args = trigger["args"]
		
		if trigger["action"] == "start_dialogue":
			node.obj = self
		elif trigger["action"] == "start_battle":
			node.obj = self
		elif trigger["action"] == "next_act":
			node.obj = Main.INSTANCE
		
		add_child(node)

func _process(delta: float):
	if not in_dialogue and not in_battle:
		var moving_right = Input.is_action_pressed("right")
		var moving_left = Input.is_action_pressed("left")
		
		if moving_right and moving_left:
			moving_right = false
			moving_left = false
		
		var speed = PUPPET_SPEED * delta
		
		if moving_right:
			Main.puppet.position.x += speed
			Main.puppet.animation_tree["parameters/blend_position"] = 1
			Main.puppet.sprite.flip_h = false
			Player.hand.position.x += speed
			Player.hand.target_position.x += speed
		elif moving_left:
			Main.puppet.position.x -= speed
			Main.puppet.animation_tree["parameters/blend_position"] = -1
			Main.puppet.sprite.flip_h = true
			Player.hand.position.x -= speed
			Player.hand.target_position.x -= speed
		else:
			if Main.puppet.animation_tree["parameters/blend_position"] == 1:
				Main.puppet.sprite.flip_h = false
			elif  Main.puppet.animation_tree["parameters/blend_position"] == -1:
				Main.puppet.sprite.flip_h = true
			Main.puppet.animation_tree["parameters/blend_position"] = 0
		
		Main.puppet.position.x = max(Main.puppet.position.x, 0)
		Player.hand.position.x = max(Player.hand.position.x, Main.screen_size.x / 4)
		Player.hand.target_position.x = max(Player.hand.target_position.x, Main.screen_size.x / 4)
		
		var screen_size = Main.screen_size
		Main.camera.position.x = Main.puppet.position.x + screen_size.x / 4
		Main.camera.target_position.x = Main.camera.position.x

func start_dialogue(args: Dictionary):
	in_dialogue = true
	Main.puppet.animation_tree["parameters/blend_position"] = 0
	dialogue = DialogueDatabase.create_dialogue(args["dialogue"])
	add_child(dialogue)

func end_dialogue():
	in_dialogue = false
	var old_dialogue = dialogue
	old_dialogue.blackout_target_opacity = 0
	old_dialogue.canvas_layer.visible = false
	await old_dialogue.reached_blackout_target_opacity
	old_dialogue.queue_free()
	old_dialogue = null

func start_battle(args: Dictionary):
	in_battle = true
	Main.puppet.sprite.flip_h = false
	Main.puppet.animation_tree["parameters/blend_position"] = 0
	
	Main.world_bgm_player.fade_speed = 0.1
	Main.battle_bgm_player.fade_speed = 3
	
	Main.world_bgm_player.target_volume_db = -80
	Main.battle_bgm_player.target_volume_db = 0
	
	Player.hand.pull_up()
	battle = Battle.SCENE.instantiate() as Battle
	
	var encounter = args["encounters"].pick_random()
	for enemy_type in encounter:
		var enemy = EnemyDatabase.create_enemy(enemy_type)
		enemy.position.x = Main.puppet.position.x + Main.screen_size.x / 2
		battle.turn_order.append(enemy)
		battle.add_child(enemy)
	battle.turn_order.push_front(Main.puppet)
	
	battle.post_dialogue = args["post_dialogue"]
	
	add_child(battle)

func end_battle():
	in_battle = false
	
	if battle.post_dialogue:
		start_dialogue({"dialogue": battle.post_dialogue})
	
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
