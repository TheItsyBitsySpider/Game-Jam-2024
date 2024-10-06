class_name RoundhouseKickCard

extends BaseCard

func play(character: Node2D):
	if character is Enemy:
		var played = super(character)
		if played:
			Main.puppet.sprite.position.x = 48
			if Main.puppet.character.weak > 0:
				character.character.hit(ceil(5 * .75))
			else:
				character.character.hit(5)
			character.character.vulnerable += 2
