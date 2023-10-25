extends Node

var pages_collected = 0

var save_path = "./settings.save"

var fullscreen = false
var screen_resolution: Vector2i = Vector2i(1152, 648)

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
var music_val = 1.0
var sfx_val = 1.0

var mouse_sensitvity = 0.003

func _ready():
	load_settings()

func save_settings():
	var config = ConfigFile.new()
	config.set_value("Settings", "fullscreen", fullscreen)
	config.set_value("Settings", "resolution", screen_resolution)
	config.set_value("Settings", "music_volume", music_val)
	config.set_value("Settings", "sfx_volume", sfx_val)
	config.set_value("Settings", "mouse_sensitivity", mouse_sensitvity)
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
		music_val = config.get_value(Settings, "music_volume")
		sfx_val = config.get_value(Settings, "sfx_volume")
		mouse_sensitvity = config.get_value(Settings, "mouse_sensitivity")
		apply_settings()

func create_settings_preferences():
	var config = ConfigFile.new()
	
	config.set_value("Settings", "fullscreen", fullscreen)
	config.set_value("Settings", "resolution", screen_resolution)
	config.set_value("Settings", "music_volume", music_val)
	config.set_value("Settings", "sfx_volume", sfx_val)
	
	config.set_value("Settings", "mouse_sensitivity", mouse_sensitvity)
	
	config.save(save_path)
	
	apply_settings()

func set_window_resolution(width, height):
	screen_resolution = Vector2i(width, height)

func apply_settings():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	if not fullscreen:
		get_window().size = screen_resolution
		var screen_size = DisplayServer.screen_get_size()
		var window_size = get_window().size
		get_window().position = screen_size*0.5 - window_size*0.5

	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(music_val))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, music_val < 0.05)
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(sfx_val))
	AudioServer.set_bus_mute(SFX_BUS_ID, sfx_val < 0.05)
