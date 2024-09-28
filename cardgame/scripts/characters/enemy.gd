class_name Enemy

extends Node2D

@onready var character: Character = $Character

func _ready():
	character.alias = "Enemy"
	character.current_health = 12
	character.total_health = 12
	
	var screen_size = get_viewport().content_scale_size
	position.x = screen_size.x / 4
