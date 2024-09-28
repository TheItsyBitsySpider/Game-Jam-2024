class_name Character

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/character.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var label: RichTextLabel = $RichTextLabel

var _alias: String
var alias: String:
	get:
		return _alias
	set(val):
		_alias = val
		_update_label()

var _current_health: int
var current_health: int:
	get:
		return _current_health
	set(val):
		_current_health = val
		_update_label()

var _total_health: int
var total_health: int:
	get:
		return _total_health
	set(val):
		_total_health = val
		_update_label()

var _defense: int
var defense: int:
	get:
		return _defense
	set(val):
		_defense = val
		_update_label()

func _update_label():
	label.text = '\n'.join([
		' '.join(["[center]", alias]),
		' '.join(["HP:", current_health, "/", total_health]),
		' '.join(["Defense:", defense])])
