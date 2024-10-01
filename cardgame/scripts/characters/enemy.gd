class_name Enemy

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/enemy.tscn")

const INTENT_DIR_PATH: String = "res://resources/intents/textures/"
const ATTACK_INTENT_TEXTURE: Resource = preload(INTENT_DIR_PATH + "attack.png")
const DEFEND_INTENT_TEXTURE: Resource = preload(INTENT_DIR_PATH + "defend.png")

@onready var character: Character = $Character
@onready var intent_sprite: Sprite2D = $UpcomingTurnSprite
@onready var intent_text: RichTextLabel = $RichTextLabel

var actions: Array[EnemyAction]
var upcoming_action: EnemyAction

func _ready():
	character.alias = "Enemy"
	character.current_health = 24
	character.total_health = 24
	
	# TODO: Enemy JSON database
	actions.append(EnemyAction.new("attack", 32, Main.puppet))
	actions.append(EnemyAction.new("defend", 10, self))
	
	character.connect("slain", _on_slain)
	character.area.connect("mouse_entered", _on_mouse_entered)
	character.area.connect("mouse_exited", _on_mouse_exited)

func _on_slain():
	# TODO: Animation and transition to non-combat scene
	Main.battle.erase_combatant(self)
	if self == Player.hovered_enemy:
		Player.hovered_enemy = null
	queue_free()

func _on_mouse_entered():
	Player.hovered_enemy = self

func _on_mouse_exited():
	Player.hovered_enemy = null

func determine_intent():
	upcoming_action = actions.pick_random()
	update_intent_label()

func ping():
	Main.battle.end_turn_button.disabled = true
	
	character.defense = 0
	
	Player.can_play = false
	while Player.hand.cards:
		await get_tree().create_timer(0.1).timeout
		Player.discard_card(Player.hand.cards.back())
	Player.can_play = true
	
	upcoming_action.action.call()
	
	Main.battle.next_turn()

func update_intent_label():
	intent_sprite.texture = null
	intent_text.text = ""
	
	var action = upcoming_action.action
	if action.get_method() == "attack":
		intent_sprite.texture = ATTACK_INTENT_TEXTURE
		intent_text.text = "[center]" + str(upcoming_action.amount)
	elif action.get_method() == "defend":
		intent_sprite.texture = DEFEND_INTENT_TEXTURE
