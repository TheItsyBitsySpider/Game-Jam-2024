class_name Trigger

extends Node2D

const SCENE: PackedScene = preload("res://scenes/trigger.tscn")

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	collision_shape.shape.size = Vector2(1, Main.screen_size.y)

func _on_area_entered(area: Area2D):
	if Main.puppet.is_ancestor_of(area):
		Main.act.start_battle()
		queue_free()
