class_name DefendCard

extends BaseCard

func play(character: Node2D):
	if character is Puppet:
		var played = super(character)
		if played:
			character.character.defense += 6
