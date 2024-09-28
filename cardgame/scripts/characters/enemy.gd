class_name Enemy

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/enemy.tscn")

@onready var character: Character = $Character

func _ready():
	character.alias = "Enemy"
	character.current_health = 12
	character.total_health = 12
	
	var screen_size = get_viewport().content_scale_size
	position.x = screen_size.x / 4

func ping():
	for card in Player.hand.cards:
		await get_tree().create_timer(0.1).timeout
		Player.hand.erase(card)
