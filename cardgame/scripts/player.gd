class_name Player

static var deck: Array[BaseCard]
static var hand: Hand = Hand.new()
static var hovered_cards: Array[BaseCard]

static var _hovered_enemy: Node2D
static var hovered_enemy: Node2D:
	get:
		return _hovered_enemy
	set(val):
		_hovered_enemy = val
		if dragged_card and dragged_card.valid_target == "enemy":
			if hovered_enemy:
				dragged_card.play_label.visible = true
			else:
				dragged_card.play_label.visible = false

static var _hovered_puppet: Node2D
static var hovered_puppet: Node2D:
	get:
		return _hovered_puppet
	set(val):
		_hovered_puppet = val
		if dragged_card and dragged_card.valid_target == "self":
			if hovered_puppet:
				dragged_card.play_label.visible = true
			else:
				dragged_card.play_label.visible = false

static var dragged_card: BaseCard

static var draw_size: int

static var can_play: bool = true
static var smother_left_click: bool = false

static func setup():
	for i in range(4):
		deck.append(CardDatabase.create_card("Hoof"))
	for i in range(4):
		deck.append(CardDatabase.create_card("Endure"))
	deck.append(CardDatabase.create_card("Roundhouse Kick"))
	deck.append(CardDatabase.create_card("Inspiration"))
	
	Main.INSTANCE.add_child(hand)
	
	draw_size = 5

static func process(_delta: float):
	smother_left_click = false
	
	if dragged_card:
		if not Input.is_action_pressed("left_click"):
			var rotation_degrees = dragged_card.rotation_degrees_before_dragging
			dragged_card.target_rotation_degrees = rotation_degrees
			if can_play:
				if hovered_enemy:
					dragged_card.play(hovered_enemy)
				if hovered_puppet:
					dragged_card.play(hovered_puppet)
			dragged_card = null
			return
		
		var mouse_position = Main.INSTANCE.get_local_mouse_position()
		var delta = mouse_position - hand.position - dragged_card.position
		dragged_card.sprite_target_position = delta

static func draw_card():
	var card = Main.battle.pop_deck()
	hand.add(card)

static func discard_card(card: BaseCard):
	Main.battle.discard_card(card)
	hand.erase(card)
