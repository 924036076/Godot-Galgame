extends TextureButton

onready var label = $Label

func _on_option_pressed():
	signal_mgr.emit_signal("on_option_clicked")

func set_dialog(text):
	label.text = text
