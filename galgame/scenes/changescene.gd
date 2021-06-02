extends CanvasLayer

onready var fade = $fade
onready var anim = $AnimationPlayer

const scene = {
	"main": "res://galgame/scenes/main.tscn",
	"menu": "res://galgame/scenes/menu.tscn"
}

func changescene(path):
	fade.show()
	anim.play("fade")
	yield(anim, "animation_finished")
	var err = get_tree().change_scene(path)
	if err != OK: return
	yield(get_tree(), "tree_changed")
	anim.play_backwards("fade")
	fade.hide()
