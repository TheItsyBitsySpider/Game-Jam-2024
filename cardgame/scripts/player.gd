class_name Player

static var deck: Array[BaseCard]
static var hand: Hand = Hand.new()
static var hovered_cards: Array[BaseCard]

static var draw_size: int

static var smother_left_click: bool = false

static func setup():
	for i in range(5):
		deck.append(CardDatabase.create_card("test_card_1"))
	for i in range(5):
		deck.append(CardDatabase.create_card("test_card_2"))
	
	draw_size = 5

static func process(_delta: float):
	smother_left_click = false

static func draw_card():
	hand.add(Main.battle.deck.back())
	Main.battle.pop_deck()
