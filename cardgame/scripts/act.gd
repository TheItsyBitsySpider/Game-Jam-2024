class_name Act

extends Node2D

const SCENE: PackedScene = preload("res://scenes/act.tscn")

const PUPPET_SPEED: int = 500

@onready var background: Sprite2D = %Background
@onready var puppet: Puppet = $Puppet

var battle: Battle
var in_battle: bool = false

func _init():
	var trigger = Trigger.SCENE.instantiate()
	trigger.position.x = Main.screen_size.x / 4
	add_child(trigger)

func _process(delta: float):
	if not in_battle:
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
		Main.INSTANCE.camera.position.x = puppet.position.x + screen_size.x / 4
		Main.INSTANCE.camera.target_position.x = Main.INSTANCE.camera.position.x

func start_battle():
	in_battle = true
	Player.hand.pull_up()
	battle = Battle.SCENE.instantiate() as Battle
	add_child(battle)

func end_battle():
	in_battle = false
	Player.hand.pull_down()
	battle.queue_free()
	battle = null
	await Player.hand.stabilized
	while Player.hand.cards:
		Player.hand.pop()
