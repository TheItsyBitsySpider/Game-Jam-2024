class_name Main

extends Node2D

static var INSTANCE: Main

func _init():
	INSTANCE = self

func _ready():
	_load()

func _load():
	CardDatabase.load_cards()

func _process(delta: float):
	Player.process(delta)
	
	# NOTE: Temporary code to test adding cards to and removing cards from hand
	if Input.is_action_just_pressed("up"):
		Player.hand.add(CardDatabase.create_card("test_card_1"))
	elif Input.is_action_just_pressed("down"):
		Player.hand.pop()
