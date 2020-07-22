extends TextureButton

signal on_option_clicked

onready var label = $Label

func _on_option_pressed():
	emit_signal("on_option_clicked")

func set_dialog(text):
	label.text = text
