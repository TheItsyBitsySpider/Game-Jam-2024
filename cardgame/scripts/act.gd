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
var post_combat_dialogue

func _init():
	pass
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

func start_dialogue(NPC: String):
	in_dialogue = true
	dialogue = DialogueDatabase.create_dialogue(NPC)
	add_child(dialogue)

func end_dialogue():
	in_dialogue = false
	
	# Prevents a crash if a new dialogue starts playing while the old one is fading
	var old_dialogue = dialogue
	
	old_dialogue.blackout_target_opacity = 0
	old_dialogue.canvas_layer.visible = false
	await old_dialogue.reached_blackout_target_opacity
	old_dialogue.queue_free()
	old_dialogue = null

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
		
	in_battle = false
	
	if post_combat_dialogue != null and not post_combat_dialogue.is_empty():
		start_dialogue(post_combat_dialogue.pop_front())

func load_act(act_number: int):
	var act_info = ActDatabase.act_database[act_number]
	
	background.texture = act_info["background"]
	var offset =  Player.hand.position.x - puppet.position.x
	
	puppet.position.x = 0
	Player.hand.position.x = 0 + offset
	Player.hand.target_position.x = 0 + offset
	
	var screen_size = Main.screen_size
	Main.camera.position.x = puppet.position.x + screen_size.x / 4
	Main.camera.target_position.x = Main.camera.position.x
	
	var old_triggers = get_tree().get_nodes_in_group("Trigger")
	for trigger in old_triggers:
		trigger.queue_free()
	
	for trigger_info in act_info["combat_triggers"]:
		var trigger = Trigger.SCENE.instantiate()
		trigger.trigger_type = Trigger.Type.BATTLE
		trigger.position.x = trigger_info[0]
		
		# Checks if this is a boss encounter or just a random enemy encounter
		if trigger_info[1] != null:
			pass # TODO implement boss encounters
		add_child(trigger)
	
	var next_act_trigger = Trigger.SCENE.instantiate()
	next_act_trigger.position.x = act_info["next_act"][0]
	next_act_trigger.act_number = act_info["next_act"][1]
	next_act_trigger.trigger_type = Trigger.Type.TRANSITION
	
	post_combat_dialogue = act_info["post_combat_dialogue"]
	
	add_child(next_act_trigger)
	if act_info["start_dialogue"] != null:
		start_dialogue(act_info["start_dialogue"])
	
