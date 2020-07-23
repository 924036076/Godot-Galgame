extends Node

onready var bgm: AudioStreamPlayer2D = $bgm
onready var voice: AudioStreamPlayer2D = $voice
onready var tween: Tween = $tween

var bgm_value = 1 
var voice_value = 1 
var text_speed_value = 1 

func _ready():
	bgm.volume_db = bgm_value * 5
	voice.volume_db = voice_value * 5
	tween.playback_speed = text_speed_value * 10

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


