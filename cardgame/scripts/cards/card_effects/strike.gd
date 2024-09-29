class_name StrikeCard

extends BaseCard

func play(character: Node2D):
	if character is Enemy:
		var played = super(character)
		if played:
			character.character.attacked(6)
