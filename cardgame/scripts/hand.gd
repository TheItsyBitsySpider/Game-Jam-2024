class_name Hand

const MAX_SIZE: int = 10

var cards: Array[BaseCard]

func add(card: BaseCard):
	if card and len(cards) < MAX_SIZE:
		Main.INSTANCE.add_child(card)
		cards.append(card)
		_draw()

func erase(card: BaseCard):
	if card:
		card.queue_free()
		cards.erase(card)
		_draw()

func pop():
	if not cards.is_empty():
		erase(cards.back())
		_draw()

func _draw():
	var width = 0
	if not cards.is_empty():
		width = (len(cards) - 1) * BaseCard.WIDTH * 0.65 + BaseCard.WIDTH
	
	var screen_size = Main.INSTANCE.get_viewport().content_scale_size
	var start_position = BaseCard.WIDTH / 2 - width / 2
	
	var i = 0
	for card in cards:
		card.global_position.x = start_position + BaseCard.WIDTH * i * 0.65
		card.global_position.y = screen_size.y / 2 - BaseCard.HEIGHT / 2.25
		
		var middle = (len(cards) - 1) / 2.0
		var delta = i - middle
		card.rotation_degrees = delta * 5
		
		var dip = sin(deg_to_rad(abs(card.rotation_degrees))) * BaseCard.WIDTH
		card.global_position.y += pow(dip * 0.25, 1.75)
		
		i += 1
