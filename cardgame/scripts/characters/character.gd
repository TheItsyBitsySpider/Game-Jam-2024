class_name Character

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/character.tscn")
const STATUS_SCENE: PackedScene = preload("res://scenes/status_effect.tscn")
const STATUS_IMAGES: Dictionary = {
	"vulnerable": preload("res://resources/debuffs/textures/vulnerable.png"),
	"weakness": preload("res://resources/debuffs/textures/weakness.png"),
	"strength": preload("res://resources/buffs/textures/strength.png")
}

const STATUS_EXPLANATIONS: Dictionary = {
	"vulnerable": "They are vulnerable, and will take 50% more damage for the next ",
	"weakness": "They are weakened, and will deal 25% less damage for the next ",
	"strength": "They are strengthed, and will deal an extra "
}

@export var override_texture: Resource

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var title_label: RichTextLabel = %Title
@onready var stats_label: RichTextLabel = %Stats
@onready var status_holder: HBoxContainer = $HBoxContainer

var _weakness_debuff
var _vulnerable_debuff
var _strength_buff

signal slain

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
		_current_health = clamp(val, 0, INF)
		if _current_health == 0:
			slain.emit()
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
		_defense = clamp(val, 0, INF)
		_update_label()

var _strength: int
var strength: int:
	get:
		return _strength
	set(val):
		_strength = val
		var explanation = STATUS_EXPLANATIONS["strength"] + str(_strength) + (" damage.")
		_strength_buff = _update_status(_strength, _strength_buff, "strength", explanation)
		_update_label()

var _weak: int
var weak: int:
	get:
		return _weak
	set(val):
		_weak = clamp(val, 0, INF)
		var explanation = STATUS_EXPLANATIONS["weakness"] + str(_weak) + (" turn." if _weak == 1 else " turns.")
		_weakness_debuff = _update_status(_weak, _weakness_debuff, "weakness", explanation)
		_update_label()

var _vulnerable: int
var vulnerable: int:
	get:
		return _vulnerable
	set(val):
		_vulnerable = clamp(val, 0, INF)
		var explanation = STATUS_EXPLANATIONS["vulnerable"] + str(_vulnerable) + (" turn." if _vulnerable == 1 else " turns.")
		_vulnerable_debuff = _update_status(_vulnerable, _vulnerable_debuff, "vulnerable", explanation)
		_update_label()

var _phantasia: int
var phantasia: int:
	get:
		return _phantasia
	set(val):
		_phantasia = clamp(val, 0, INF)
		_update_label()

func _ready():
	if override_texture:
		sprite.texture = override_texture

func hit(damage: int):
	if vulnerable > 0:
		damage = ceil(damage * 1.5)
	current_health -= clamp((damage - defense), 0, INF)
	defense -= damage

func _update_label():
	title_label.text = "[center]" + alias
	stats_label.text = '\n'.join([
		' '.join(["[center][color=#b38b2b]HP:[/color]", str(current_health) + "/" + str(total_health)]),
		' '.join(["[color=#b38b2b]Block:[/color]", defense])])

func _update_status(amt: int, status, status_img: String, explanation: String):
	if amt > 0 and status == null:
		status = STATUS_SCENE.instantiate()
		status_holder.add_child(status)
		status.text.text = str(amt)
		status.sprite.texture = STATUS_IMAGES[status_img]
		status.sprite.scale = Vector2(.1, .1)
		status.status_explanation_text.text = explanation
	elif amt > 0 and status != null:
		status.text.text = str(amt)
		status.status_explanation_text.text = explanation
	elif amt == 0 and status != null:
		status_holder.remove_child(status)
		status.queue_free()
		status = null
	return status
