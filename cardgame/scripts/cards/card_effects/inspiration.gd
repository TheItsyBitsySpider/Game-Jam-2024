class_name InspirationCard

extends BaseCard

func play(character: Node2D):
	if character is Puppet:
		var played = super(character)
		if played:
			character.character.phantasia += 1
			Player.draw_card()
