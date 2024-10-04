class_name Trigger

extends Node2D

const SCENE: PackedScene = preload("res://scenes/trigger.tscn")

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var text: RichTextLabel = $RichTextLabel

enum Type {BATTLE, TRANSITION}

var trigger_type: Type
var text_to_use: String
var act_number: int

func _ready():
	collision_shape.shape.size = Vector2(1, Main.screen_size.y)

func _on_area_entered(area: Area2D):
	if Main.puppet.is_ancestor_of(area) and trigger_type == Type.BATTLE:
		Main.act.start_battle()
		queue_free()
	elif Main.puppet.is_ancestor_of(area) and trigger_type == Type.TRANSITION:
		text.text = text_to_use
		text.visible = true
		Main.act.load_act(act_number)
		
func _on_area_exited(area):
	if Main.puppet.is_ancestor_of(area) and trigger_type == Type.TRANSITION:
		text.visible = false
