class_name Enemy

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/enemy.tscn")

@onready var character: Character = $Character

func _ready():
	character.alias = "Enemy"
	character.current_health = 12
	character.total_health = 12
	
	character.area.connect("mouse_entered", _on_mouse_entered)
	character.area.connect("mouse_exited", _on_mouse_exited)
	
	var screen_size = get_viewport().content_scale_size
	position.x = screen_size.x / 4

func _on_mouse_entered():
	Player.hovered_enemy = self

func _on_mouse_exited():
	Player.hovered_enemy = null

func ping():
	Main.battle.end_turn_button.disabled = true
	
	while Player.hand.cards:
		await get_tree().create_timer(0.1).timeout
		Player.discard_card(Player.hand.cards.back())
