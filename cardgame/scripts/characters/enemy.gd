class_name Enemy

extends Node2D

const SCENE: PackedScene = preload("res://scenes/characters/enemy.tscn")

const INTENT_DIR_PATH: String = "res://resources/intents/textures/"
const ATTACK_INTENT_TEXTURE: Resource = preload(INTENT_DIR_PATH + "attack.png")
const DEFEND_INTENT_TEXTURE: Resource = preload(INTENT_DIR_PATH + "defend.png")
const BUFF_INTENT_TEXTURE: Resource = preload(INTENT_DIR_PATH + "buff.png")
const DEBUFF_INTENT_TEXTURE: Resource = preload(INTENT_DIR_PATH + "debuff.png")

@onready var character: Character = $Character
@onready var intent_sprite: TextureRect = $UpcomingTurnSprite
@onready var intent_text: RichTextLabel = $RichTextLabel
@onready var intent_explanation: Control = $IntentExplanation
@onready var intent_explanation_text: RichTextLabel = $IntentExplanation/RichTextLabel2

var actions: Array[EnemyAction]
var upcoming_action: EnemyAction
var action_index: int = 0

var data: Dictionary

var random_actions: bool:
	get:
		return data["random_actions"]

func _ready():
	setup()
	
	character.connect("slain", _on_slain)
	character.area.connect("mouse_entered", _on_mouse_entered)
	character.area.connect("mouse_exited", _on_mouse_exited)

func setup():
	var viable_targets = {
		"self": self,
		"puppet": Main.puppet
	}
	
	character.alias = data["name"]
	character.current_health = data["health"]
	character.total_health = data["health"]
	
	character.sprite.texture = data["texture"]
	character.sprite.scale = Vector2(.5, .5)
	
	for action in data["actions"]:
		var type = action[0]
		var amount = action[1]
		var target = viable_targets[action[2]]
		var stats = character
		actions.append(EnemyAction.new(type, amount, target, stats))

func _on_slain():
	# TODO: Animation and transition to non-combat scene
	Main.battle.erase_combatant(self)
	if self == Player.hovered_enemy:
		Player.hovered_enemy = null
	queue_free()

func _on_mouse_entered():
	Player.hovered_enemy = self
	print("HOVERED ENEMY")

func _on_mouse_exited():
	Player.hovered_enemy = null
	print("OFF ENEMY")

func determine_intent():
	if random_actions:
		upcoming_action = actions.pick_random()
	else:
		upcoming_action = actions[action_index % len(actions)]
		action_index += 1
	update_intent_label()

func _explain_intent():
	intent_explanation.visible = true

func _progress_debuffs():
	character.weak -= 1
	character.vulnerable -= 1

func ping():
	Main.battle.end_turn_button.disabled = true
	
	character.defense = 0
	_progress_debuffs()
	
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
		var upcoming_damage = upcoming_action.amount + character.strength
		intent_sprite.texture = ATTACK_INTENT_TEXTURE
		intent_text.text = "[center]" + str(upcoming_damage)
		intent_explanation_text.text = "[center]" + "The enemy intends to attack you for " + str(upcoming_damage) + " damage."
	elif action.get_method() == "defend":
		intent_sprite.texture = DEFEND_INTENT_TEXTURE
		intent_explanation_text.text = "[center]" + "The enemy intends to defend itself."
	elif action.get_method().begins_with("buff"):
		intent_sprite.texture = BUFF_INTENT_TEXTURE
		intent_explanation_text.text = "[center]" + "The enemy intends to buff itself."
	elif action.get_method().begins_with("debuff"):
		intent_sprite.texture = DEBUFF_INTENT_TEXTURE
		intent_explanation_text.text = "[center]" + "The enemy intends to inflict a debuff on you."
