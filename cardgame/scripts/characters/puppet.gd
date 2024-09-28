class_name Puppet

extends Node2D

@onready var character: Character = $Character

var current_energy: int
var total_energy: int

func _ready():
	character.alias = "Puppet"
	character.current_health = 50
	character.total_health = 50
	
	current_energy = 3
	total_energy = 3
	
	var screen_size = get_viewport().content_scale_size
	position.x = -screen_size.x / 4
