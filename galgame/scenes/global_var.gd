extends Node

onready var bgm: AudioStreamPlayer2D = $bgm
onready var voice: AudioStreamPlayer2D = $voice
onready var tween: Tween = $tween

var bgm_value = 0 
var voice_value = 0 
var text_speed_value = 0.1 

# --- virtual methods ---

func _ready():
	load_global_var()

func _exit_tree():
	save_global_var()

# --- public methods ---

func save_global_var():
	var dict = { 
		"text_speed": global_var.text_speed_value,
		"voice_volume": global_var.voice_value,
		"bgm_volume": global_var.bgm_value
	}
	file_mgr.save_file(dict)

func load_global_var():
	var data = file_mgr.load_file()
	bgm.volume_db = data["bgm_volume"] * 5
	voice.volume_db = data["voice_volume"] * 5
	tween.playback_speed = data["text_speed"] * 10

func set_bgm_value(value):
	bgm.volume_db = value * 5
	bgm_value = value

func set_voice_value(value):
	voice.volume_db = value * 5
	voice_value = value

func set_text_speed_value(value):
	tween.playback_speed = value * 10
	text_speed_value = value

func dotween(target: Object, prop: String):
	tween.interpolate_property(target, prop, 0, 1, 1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func replay():
	bgm.seek(0)
