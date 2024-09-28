class_name Player

static var hand: Hand = Hand.new()
static var hovered_cards: Array[BaseCard]

static var smother_left_click: bool = false

static func process(_delta: float):
	smother_left_click = false
