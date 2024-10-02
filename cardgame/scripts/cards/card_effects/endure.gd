class_name EndureCard

extends BaseCard

func play(character: Node2D):
	if character is Puppet:
		var played = super(character)
		if played:
			character.character.defense += 3
