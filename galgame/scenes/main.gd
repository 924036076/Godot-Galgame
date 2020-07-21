extends Control

onready var bg = $bg
onready var character = $character
onready var speaker_label = $dialog/speaker_label
onready var dialog_label =$dialog/dialog_label
onready var tween = $dialog/dialog_label/Tween
onready var option_list = $option_list
onready var audio_player = $audio_player

onready var option = load("res://galgame/scenes/ui/option.tscn")

var index: int = 0
var text_speed = 0.02

# ---- virtual methods ----

func _ready():
	signal_mgr.register("setname", self, "_on_set_name")
	signal_mgr.register("setsprite", self, "_on_set_sprite")
	signal_mgr.register("settext", self, "_on_set_text")
	signal_mgr.register("setoption", self, "_on_set_option")
	signal_mgr.register("setfinsh", self, "_on_set_finsh")
	galgame_reader.play_dialog("res://galgame/stories/stiory00.tres")


func _input(event):
	if event is InputEventKey:
		if event.pressed == true and event.scancode == KEY_SPACE:
			_on_pressed_space()

# ---- private methods ----

func _on_set_name(name):
	speaker_label.text = name

func _on_set_sprite(msg: String):
	if msg == "": 
		for img in character.get_children():
			img.visible = false
	else:
		var list = msg.split("|")
		var img: TextureRect = character.get_node(list[0])
		img.texture = load(list[1])
		if img.visible == false:
			img.visible = true
		
		if list[2] != "":
			var ogg = load(list[2])
			print(list[2])
			ogg.loop = false
			audio_player.stream = ogg
			audio_player.play()

func _on_set_text(text):
	dialog_label.percent_visible = 0
	dialog_label.text = text
	var time = text_speed * text.length()
	tween.interpolate_property(dialog_label, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func _on_set_option(dict: Dictionary):
	for item in dict:
		var option_btn = option.instance()
		option_list.add_child(option_btn)
		option_btn.set_dialog(dict[item])
		signal_mgr.register("on_option_clicked", self, item)

func _on_set_finsh():
	print("结束")

func restart():
	_on_click_option()
	Changescene.changescene("res://galgame/scenes/main.tscn")

func tomenu():
	_on_click_option()
	Bgm.replay()
	Changescene.changescene("res://galgame/scenes/menu.tscn")

func _on_click_option():
	galgame_reader.is_option = false
	for option in option_list.get_children():
		option_list.remove_child(option)
		option.queue_free()

func _is_playing():
	if dialog_label.percent_visible < 1:
		return true
	else:
		return false

func _on_pressed_space():
	if _is_playing() == false:
		galgame_reader.index += 1
		galgame_reader.play_next_node()
	else:
		dialog_label.percent_visible = 1
		tween.stop(dialog_label)

func _on_dialog_bg_pressed():
	_on_pressed_space()
