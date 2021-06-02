extends Node

const SAVE_DIR = "user://saves/"
const save_path = SAVE_DIR + "global_data.dat"
const password = "h4g4wa6fz5th4h"

func save_file(data):
	var directory: Directory = Directory.new()
	if !directory.dir_exists(SAVE_DIR):
		directory.make_dir_recursive(SAVE_DIR)
	var file: File = File.new()
	var err = file.open_encrypted_with_pass(save_path, File.WRITE, password)
	if err == OK:
		file.store_var(data)
		file.close()

func load_file():
	var file:File = File.new()
	var data = null
	if file.file_exists(save_path):
		var err = file.open_encrypted_with_pass(save_path, File.READ, password)
		if err == OK:
			data = file.get_var()
			file.close()
	return data
