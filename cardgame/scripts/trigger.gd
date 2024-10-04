class_name Trigger

extends Node2D

const SCENE: PackedScene = preload("res://scenes/trigger.tscn")

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var obj: Object
var action: String
var args: Dictionary

func _ready():
	collision_shape.shape.size = Vector2(1, Main.screen_size.y)

func _on_area_entered(area: Area2D):
	if Main.puppet.is_ancestor_of(area) and not Main.in_transition:
		obj.callv(action, [args])
		queue_free()
