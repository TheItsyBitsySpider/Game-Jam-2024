class_name HoofCard

extends BaseCard

func play(character: Node2D):
	if character is Enemy:
		var played = super(character)
		if played:
			if Main.puppet.character.weak > 0:
				character.character.hit(ceil(3 * .75))
			else:
				character.character.hit(3)
