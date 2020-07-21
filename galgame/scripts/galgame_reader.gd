extends Node

var content_list
var index = 0
var is_over = false
var is_option = false

# ---- public methods ----

func play_dialog(story_path: String):
	if is_over: return
	if is_option: return
	var file: File = File.new()
	var err = file.open(story_path, File.READ)
	if err == OK:
		var content = file.get_as_text()
		content_list = content.split('\n')
	file.close()
	play_next_node()

func play_next_node():
	if is_over: return
	if is_option: return
	if content_list.size() <= index: return 
	var text: String = content_list[index]
	if "<<" and ">>" in text:
		var content = text.replace('<<', '').replace('>>', '')
		var list: PoolStringArray= content.split('|', true, 1)
		if list.size() > 1: signal_mgr.emit_signal(list[0], list[1])
		index = index + 1
		play_next_node()
	elif "[[" and "]]" in text:
		is_option = true
		var content = text.replace('[[', '').replace(']]', '')
		var dict: Dictionary= parse_json(content)
		signal_mgr.emit_signal("setoption", dict)
	elif "##" == text:
		signal_mgr.emit_signal("setfinsh")
		is_over = true
	else:
		signal_mgr.emit_signal("settext", content_list[index])
