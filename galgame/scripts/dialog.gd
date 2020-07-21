extends Reference
class_name DialogPlayer

onready var option = load("res://galgame/scenes/ui/option.tscn")

signal on_story_finish(did)

var story_reader: StoryReader = null
var did = 1
var nid = 1
var final_nid = 1

var option_list: Control = null
var character: Control = null
var dialog_label: Label = null
var bg: TextureRect = null
var speaker_label: Label = null
var tween: Tween = null
var audio_player: AudioStreamPlayer2D = null
var text_speed = 0.02

var registry: Dictionary = {}
var texture_dict: Dictionary = {}
var audio_dict: Dictionary = {}


# ---- virtual methods ----

func _init(option_list, character, audio_player, dialog_label, bg, speaker_label, texture_dict, audio_dict):
	self.option_list = option_list
	self.character = character
	self.dialog_label = dialog_label
	self.bg = bg
	self.tween = self.dialog_label.get_node('Tween')
	self.speaker_label = speaker_label
	self.texture_dict = texture_dict
	self.audio_dict = audio_dict
	self.audio_player = audio_player
	
	var story_reader_class = load("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
	story_reader = story_reader_class.new()
	var story = load("res://galgame/stories/stiory01_bake.tres")
	story_reader.read(story)
	_clear_options()

# ---- callback methods ----

func _on_Option_clicked(slot):
	_get_next_node(slot)
	_clear_options()


# ---- public methods ----

func play_dialog():
	nid = story_reader.get_nid_via_exact_text(did, "<start>")
	final_nid = story_reader.get_nid_via_exact_text(did, "<end>")
	_get_next_node()
	_play_node()

func play_next_node():
	if !_is_playing():
		_get_next_node()
		_play_node()

func register(key, value):
	registry[key] = value

func unregister(key):
	if registry.has(key):
		registry.erase(key)

# ---- private methods ----

func _is_playing():
	if dialog_label.percent_visible < 1:
		return true
	else:
		return false

func display_image(key):
	return load(texture_dict[key])

func _play_node():
	var text = _inject_variables()
	var speaker_text = _get_tagged_text("speaker", text)
	var dialog = _get_tagged_text("dialog", text)
	var character_key = null 
	if "<choice>" in text:
		var options = _get_tagged_text("choice", text)
	if "<character>" in text:
		character_key = _get_tagged_text("character", text)
		
	var is_show = false
	if "<show>" in text:
		is_show = true
	elif "<hide>" in text :
		is_show = false
	
	var texture_rect: TextureRect = null
	if "<left>" in text:
		texture_rect = self.character.get_node("left")
	elif "<center>" in text:
		texture_rect = self.character.get_node("center")
	elif "<right>" in text:
		texture_rect = self.character.get_node("right")
	if texture_rect != null:
		texture_rect.visible = is_show
		texture_rect.texture = display_image(character_key)
	
	if "<audio>" in text:
		var clip = _get_tagged_text("audio", text)
		var ogg = load(audio_dict[clip])
		ogg.loop = false
		audio_player.stream = load(audio_dict[clip])
		audio_player.play()
	
	if "<backgourd>" in text:
		var bg = self.character.get_node("backgourd")
		self.bg.texture = display_image(bg)
	
	speaker_label.text = speaker_text
	dialog_label.text = dialog
	var time = text_speed * dialog.length()
	tween.interpolate_property(dialog_label, "percent_visible", 0, 1, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func _get_next_node(slot : int = 0):
	print(did)
	print(story_reader)
	nid = story_reader.get_nid_from_slot(did, nid, slot)
	
	if nid == final_nid:
		emit_signal("on_story_finish", did)

func _get_tagged_text(tag : String, text : String):
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substr_length = end_index - start_index
	return text.substr(start_index, substr_length)

func _inject_variables():
	var text = story_reader.get_text(did, nid)
	var variable_count = text.count("<var>")
	for i in range(variable_count):
		var variable_name = _get_tagged_text("var", text)
		var start_index = text.find("<var>")
		var end_index = text.find("</var>") + "</var>".length()
		var substr_length = end_index - start_index
		text.erase(start_index, substr_length)
		text = text.insert(start_index, str(_lookup(variable_name)))
	
	return text

func _populate_choices(json):
	var choices : Dictionary = parse_json(json)
	
	for text in choices:
		var slot = choices[text]
		var option_btn = option.instance()
		option_list.add_child(option_btn)
		option_btn.slot = slot
		option_btn.set_dialog(text)
		option_btn.connect("on_option_clicked", self, "_on_Option_clicked")

func _clear_options():
	var children = option_list.get_children()
	for child in children:
		option_list.remove_child(child)
		child.queue_free()


func _lookup(name : String):
	if registry.has(name):
		return registry[name]
	else:
		return ""
