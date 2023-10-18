extends Node

var pages_collected = 0

var save_path = "./settings.save"

var fullscreen = false

func _ready():
	load_settings()

func save_settings():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(fullscreen)
	apply_settings()

func load_settings():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		fullscreen = file.get_var(fullscreen)
		apply_settings()
	else:
		create_settings_preferences()

func create_settings_preferences():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(fullscreen)
	apply_settings()

func apply_settings():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
