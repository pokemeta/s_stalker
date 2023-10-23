extends Node

var pages_collected = 0

var save_path = "./settings.save"

var fullscreen = false
var screen_resolution: Vector2i = Vector2i(1152, 648)

func _ready():
	load_settings()

func save_settings():
	var config = ConfigFile.new()
	config.set_value("Settings", "fullscreen", fullscreen)
	config.set_value("Settings", "resolution", screen_resolution)
	config.save(save_path)
	apply_settings()

func load_settings():
	var config = ConfigFile.new()
	var error = config.load(save_path)
	if error != OK:
		create_settings_preferences()
	
	for Settings in config.get_sections():
		fullscreen = config.get_value(Settings, "fullscreen")
		screen_resolution = config.get_value(Settings, "resolution")
		apply_settings()

func create_settings_preferences():
	var config = ConfigFile.new()
	
	config.set_value("Settings", "fullscreen", fullscreen)
	config.set_value("Settings", "resolution", screen_resolution)
	
	config.save(save_path)
	
	apply_settings()

func set_window_resolution(width, height):
	screen_resolution = Vector2i(width, height)

func apply_settings():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	get_window().size = screen_resolution
	var screen_size = DisplayServer.screen_get_size()
	var window_size = get_window().size
	get_window().position = screen_size*0.5 - window_size*0.5
