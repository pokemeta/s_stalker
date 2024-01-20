extends Control

@onready var buttons = $Buttons
@onready var config_buttons = $ConfigButtons
@onready var fullscreen_check = $ConfigButtons/Fullscreen_check
@onready var resolution_options = $ConfigButtons/GridContainer/ResolutionOptions

@onready var music_slider = $ConfigButtons/GridContainer2/MusicSlider
@onready var sfx_slider = $ConfigButtons/GridContainer3/SFXSlider

@onready var debug_hud = $"../DebugHUD"

@onready var sensitivity_count = $ConfigButtons/GridContainer4/GridContainer/sensitivity_count
@onready var mouse_sensitivity_slider = $ConfigButtons/GridContainer4/GridContainer/Mouse_Sensitivity_Slider

func _ready():
	fullscreen_check.button_pressed = Globals.fullscreen
	resolution_options.disabled = Globals.fullscreen
	
	music_slider.value = Globals.music_val
	sfx_slider.value = Globals.sfx_val
	
	mouse_sensitivity_slider.value = Globals.mouse_sensitvity
	sensitivity_count.text = str(Globals.mouse_sensitvity)
	
	add_items()

func add_items():
	resolution_options.add_item("800x600")
	resolution_options.add_item("1152x648")

func _on_return_pressed():
	visible = false
	get_tree().paused = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_configuration_pressed():
	buttons.visible = false
	config_buttons.visible = true

func _on_back_pressed():
	buttons.visible = true
	config_buttons.visible = false

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

func _on_music_slider_value_changed(value):
	Globals.music_val = value

func _on_sfx_slider_value_changed(value):
	Globals.sfx_val = value
	
func _on_mouse_sensitivity_slider_value_changed(value):
	Globals.mouse_sensitvity = value
	sensitivity_count.text = str(Globals.mouse_sensitvity)
	
func _on_apply_pressed():
	Globals.fullscreen = fullscreen_check.button_pressed
	resolution_options.disabled = Globals.fullscreen
	Globals.save_settings()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func _on_debug_pressed():
	debug_hud.visible = !debug_hud.visible


