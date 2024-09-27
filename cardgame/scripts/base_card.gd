class_name BaseCard

extends Node2D

var card_stats : Dictionary

func play():
	print("Nothing")
	
func card_setup():
	var card_art = $Sprite2D as Sprite2D
	var clickable_area = $Area2D/CollisionShape2D as CollisionShape2D
	var area2d = $Area2D
	
	card_art.texture = load(card_stats["sprite"])
	clickable_area.shape.extents.x = card_art.texture.get_size()[0]/2
	clickable_area.shape.extents.y = card_art.texture.get_size()[1]/2
	area2d.connect("input_event", _process_mouse)

func _process_mouse(viewport, event, shape):
	# Could process other mouse events, such as when hovering over the card
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		play()
	
