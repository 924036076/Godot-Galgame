extends Control

onready var text_speed_slider = $panel/container/sub_container/text_speed_slider
onready var bgm_slider = $panel/container/sub_container2/bgm_slider
onready var voice_slider = $panel/container/sub_container3/voice_slider

func _on_text_speed_slider_value_changed(value):
	global_var.set_text_speed_value(value)

func _on_bgm_slider_value_changed(value):
	if value == bgm_slider.min_value:
		value = -80
	global_var.set_bgm_value(value)

func _on_voice_slider_value_changed(value):
	if value == bgm_slider.min_value:
		value = -80
	global_var.set_voice_value(value)

func update():
	text_speed_slider.value = global_var.text_speed_value
	bgm_slider.value = global_var.bgm_value
	voice_slider.value = global_var.voice_value


func _on_menu_pressed():
	galgame_reader.index = 0
	global_var.save_global_var()
	galgame_reader.is_option = false
	global_var.replay()
	change_scene.changescene(change_scene.scene.menu)

func _on_resume_pressed():
	global_var.save_global_var()
	visible = false
