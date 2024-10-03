class_name Dialogue

extends Node2D

const SCENE: PackedScene = preload("res://scenes/dialogue.tscn")
const FADE_SPEED: int = 5
const BLACKOUT_FADE_SPEED: int = 3
const NEXT_INDICATOR_FADE_SPEED: int = 5

@onready var blackout: TextureRect = %Blackout
@onready var canvas_layer: CanvasLayer = $CanvasLayer2

@onready var dialogue_container: Container = %DialogueContainer
@onready var box: TextureRect = %Box
@onready var character_name: RichTextLabel = %Name
@onready var dialogue: RichTextLabel = %Dialogue
@onready var next_indicator: TextureRect = %Next

@onready var portrait_container: Container = %PortraitContainer
@onready var portrait: TextureRect = %Portrait

var data: Array

var character_alias: String:
	get:
		return data[dialogue_index]["character_name"]

var text: String:
	get:
		return data[dialogue_index]["dialogue"]

var type_by_word: bool:
	get:
		return DialogueDatabase.character_data[character_alias]["type_by_word"]

var _dialogue_index: int
var dialogue_index: int:
	get:
		return _dialogue_index
	set(val):
		_dialogue_index = val
		
		if dialogue_index >= len(data):
			Main.act.end_dialogue()
			return
		
		dialogue_container.modulate.a = 0
		portrait_container.modulate.a = 0
		
		character_name.text = character_alias
		
		var character_data = DialogueDatabase.character_data[character_alias]
		portrait.texture = character_data["texture"]
		
		dialogue.text = ""
		var font_style = character_data["font_style"]
		var font_size = character_data["font_size"]
		dialogue.add_theme_font_override("normal_font", font_style)
		dialogue.add_theme_font_size_override("normal_font_size", font_size)
		typewriter_speed = character_data["typewriter_speed"]
		
		var typewriter = get_tree().create_timer(typewriter_speed)
		typewriter.timeout.connect(_on_typewriter_timeout)
		
		next_indicator.modulate.a = 0
		next_indicator_target_opacity = 0

var typewriter_speed: float

var target_opacity: float
var blackout_target_opacity: float
var next_indicator_target_opacity: float

signal reached_blackout_target_opacity

func _ready():
	target_opacity = 1
	blackout_target_opacity = 1
	dialogue_index = 0

func _process(delta: float):
	if abs(blackout.modulate.a - blackout_target_opacity) > 0.01:
		blackout.modulate.a = lerp(blackout.modulate.a,
								   blackout_target_opacity,
								   BLACKOUT_FADE_SPEED * delta)
		if abs(blackout.modulate.a - blackout_target_opacity) <= 0.01:
			reached_blackout_target_opacity.emit()
	
	dialogue_container.modulate.a = lerp(dialogue_container.modulate.a,
										 target_opacity,
										 FADE_SPEED * delta)
	
	portrait_container.modulate.a = lerp(portrait_container.modulate.a,
										 target_opacity,
										 FADE_SPEED * delta)
	
	next_indicator.modulate.a = lerp(next_indicator.modulate.a,
									 next_indicator_target_opacity,
									 NEXT_INDICATOR_FADE_SPEED * delta)
	
	if Input.is_action_just_pressed("advance_dialogue"):
		if blackout_target_opacity == 1:
			if len(dialogue.text) == len(text):
				dialogue_index += 1
			else:
				dialogue.text = text
				next_indicator.modulate.a = 1
				next_indicator_target_opacity = 1

func _on_typewriter_timeout():
	if len(dialogue.text) < len(text):
		if not type_by_word:
			var index = len(dialogue.text)
			var char = text[index]
			if char == '[':
				var tag = text.substr(index, text.find("]", index) - index + 1)
				dialogue.text += tag
				return _on_typewriter_timeout()
			dialogue.text += char
		else:
			var word = text.trim_prefix(dialogue.text).split(' ', false)[0]
			dialogue.text += (" " if dialogue.text else "") + word
		var typewriter = get_tree().create_timer(typewriter_speed)
		typewriter.timeout.connect(_on_typewriter_timeout)
	else:
		next_indicator_target_opacity = 1
