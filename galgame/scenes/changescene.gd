extends CanvasLayer

onready var fade = $fade
onready var anim = $AnimationPlayer

func changescene(path):
	fade.show()
	anim.play("fade")
	yield(anim, "animation_finished")
	var err = get_tree().change_scene(path)
	if err != OK: return 
	anim.play_backwards("fade")
	fade.hide()

