class_name Enemy

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/enemy.tscn")
const ATTACK_INTENT: Resource = preload("res://resources/cards/intents/Attack.png")
const DEFEND_INTENT: Resource = preload("res://resources/cards/intents/Defend.png")


var actions: Array[EnemyAction]
var action_to_perform: EnemyAction

@onready var character: Character = $Character
@onready var intent_sprite: Sprite2D = $UpcomingTurnSprite
@onready var intent_text: RichTextLabel = $RichTextLabel

func _ready():
	character.alias = "Enemy"
	character.current_health = 24
	character.total_health = 24
	
	# Later create a json database like the card one that specifies which actions should be addded depending on the enemy
	actions.append(EnemyAction.new("damage", 32, Main.battle.puppet))
	actions.append(EnemyAction.new("defend", 10, self))
	
	character.area.connect("mouse_entered", _on_mouse_entered)
	character.area.connect("mouse_exited", _on_mouse_exited)
	character.connect("is_dead", _on_death)
	
	var screen_size = get_viewport().content_scale_size
	position.x = screen_size.x / 4

func _on_mouse_entered():
	Player.hovered_enemy = self

func _on_mouse_exited():
	Player.hovered_enemy = null

func _on_death():
	# Should be replaced later with an animation + transition from combat to non-combat
	queue_free()
	print("WON THE FIGHT")

func pick_attack():
	action_to_perform = actions.pick_random()
	update_intent_label()

func ping():
	Main.battle.end_turn_button.disabled = true
	character.defense = 0
	while Player.hand.cards:
		await get_tree().create_timer(0.1).timeout
		Player.discard_card(Player.hand.cards.back())
	action_to_perform.action_selected.call()
	Main.battle.next_turn()

func update_intent_label():
	intent_sprite.texture = null
	intent_text.text = ""
	var action = action_to_perform.action_selected
	if action.get_method() == "damage":
		intent_sprite.texture = ATTACK_INTENT
		intent_text.text = "[center]" + str(action_to_perform.amount)
	elif action.get_method() == "defend":
		intent_sprite.texture = DEFEND_INTENT
	intent_sprite.scale = Vector2(1, 1)
