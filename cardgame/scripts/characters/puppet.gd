class_name Puppet

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/puppet.tscn")
const SPEED: int = 5

@onready var character: Character = $Character
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

var _current_energy: int
var current_energy: int:
	get:
		return _current_energy
	set(val):
		_current_energy = val
		
		for card in Player.hand.cards:
			if card.cost <= val:
				card.modulate.a = 1
				card.target_opacity = 1
			else:
				card.target_opacity = 0.6
		
		if Main.battle:
			Main.battle.energy_label_color = Battle.LABEL_ACTIVE_COLOR
			Main.battle.update_energy_label(current_energy, total_energy)

var _total_energy: int
var total_energy: int:
	get:
		return _total_energy
	set(val):
		_total_energy = val
		
		if Main.battle:
			Main.battle.update_energy_label(current_energy, total_energy)

var sprite_target_position: float

func _ready():
	character.alias = "A5"
	character.current_health = 50
	character.total_health = 50
	character.strength = 0
	
	current_energy = 3
	total_energy = 3
	
	character.connect("slain", _on_slain)
	character.area.connect("mouse_entered", _on_mouse_entered)
	character.area.connect("mouse_exited", _on_mouse_exited)
	
	position.x = -Main.screen_size.x / 4

func _process(delta: float):
	var speed = SPEED * delta
	sprite.position.x = lerp(sprite.position.x, sprite_target_position, speed)

func _on_slain():
	pass

func _on_mouse_entered():
	Player.hovered_puppet = self

func _on_mouse_exited():
	Player.hovered_puppet = null

func _progress_debuffs():
	character.weak -= 1
	character.vulnerable -= 1

func ping():
	Main.battle.end_turn_button.disabled = false

	character.defense = 0
	_progress_debuffs()
	current_energy = total_energy
	
	get_tree().call_group("enemy", "determine_intent")
	if character.current_health <= 0:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			Main.battle.erase_combatant(enemy)
		return
	for i in range(Player.draw_size):
		await get_tree().create_timer(0.1).timeout
		Player.draw_card()
