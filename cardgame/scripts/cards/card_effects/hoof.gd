class_name HoofCard

extends BaseCard

func _init():
	valid_target = "enemy"

func play(character: Node2D):
	if character is Enemy:
		var played = super(character)
		if played:
			Main.puppet.sprite.position.x = 48
			if Main.puppet.character.weak > 0:
				character.character.hit(ceil(3 * .75))
			else:
				character.character.hit(3)
