class_name Puppet

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/puppet.tscn")

@onready var character: Character = $Character

var _current_energy: int
var current_energy: int:
	get:
		return _current_energy
	set(val):
		_current_energy = val
		
		if Main.battle:
			Main.battle.update_energy_label(current_energy, total_energy)

var _total_energy: int
var total_energy: int:
	get:
		return _total_energy
	set(val):
		_total_energy = val
		
		if Main.battle:
			Main.battle.update_energy_label(current_energy, total_energy)

func _ready():
	character.alias = "Puppet"
	character.current_health = 50
	character.total_health = 50
	
	current_energy = 3
	total_energy = 3
	
	var screen_size = get_viewport().content_scale_size
	position.x = -screen_size.x / 4

func ping():
	Main.battle.end_turn_button.disabled = false
	
	character.defense = 0
	current_energy = total_energy
	
	for i in range(Player.draw_size):
		await get_tree().create_timer(0.1).timeout
		Player.draw_card()
