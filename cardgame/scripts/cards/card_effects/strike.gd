class_name StrikeCard

extends BaseCard

func play(character: Node2D):
	var played = super(character)
	if played:
		print(' '.join([alias, cost]))
