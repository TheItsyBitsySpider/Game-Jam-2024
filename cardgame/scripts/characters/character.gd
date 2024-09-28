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
		label.text = val
		_alias = val

var current_health: int
var total_health: int
var defense: int
