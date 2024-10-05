extends Control

@onready var sprite: TextureRect = $TextureRect
@onready var text: RichTextLabel = $RichTextLabel
@onready var status_explanation_box: Control = $Control
@onready var status_explanation_text: RichTextLabel = $Control/RichTextLabel

func _on_texture_rect_mouse_entered():
	status_explanation_box.visible = true


func _on_texture_rect_mouse_exited():
	status_explanation_box.visible = false
