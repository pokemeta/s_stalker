extends Control

@onready var main_container = $Main_container
@onready var config_container = $Config_container

@onready var fullscreen_check = $Config_container/Fullscreen_check
@onready var resolution_options = $Config_container/GridContainer/ResolutionOptions

@onready var bg_menu = $BG_menu

@onready var music_slider = $Config_container/GridContainer2/MusicSlider
@onready var sfx_slider = $Config_container/GridContainer3/SFXSlider

func _ready():
	add_items()
	
	fullscreen_check.button_pressed = Globals.fullscreen
	resolution_options.disabled = Globals.fullscreen
	
	music_slider.value = Globals.music_val
	sfx_slider.value = Globals.sfx_val
	
	bg_menu.play()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://world_navmeshtest.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_config_button_pressed():
	main_container.visible = false
	config_container.visible = true

func _on_return_button_pressed():
	main_container.visible = true
	config_container.visible = false
	
func _on_resolution_options_item_selected(index):
	var current_selected = index
	var width = 0
	var height = 0
	match(current_selected):
		0:
			width = 800
			height = 600
		1:
			width = 1152
			height = 648
	Globals.set_window_resolution(width, height)

func add_items():
	resolution_options.add_item("800x600")
	resolution_options.add_item("1152x648")

func _on_apply_button_pressed():
	Globals.fullscreen = fullscreen_check.button_pressed
	resolution_options.disabled = Globals.fullscreen
	Globals.save_settings()

func _on_music_slider_value_changed(value):
	Globals.music_val = value

func _on_sfx_slider_value_changed(value):
	Globals.sfx_val = value
