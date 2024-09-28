class_name Enemy

extends Node2D

@onready var character: Character = $Character

func _ready():
	character.alias = "Enemy"
	
	var screen_size = get_viewport().content_scale_size
	position.x = screen_size.x / 4
