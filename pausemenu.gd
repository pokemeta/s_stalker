extends Control

@onready var buttons = $Buttons
@onready var config_buttons = $ConfigButtons
@onready var fullscreen_check = $ConfigButtons/Fullscreen_check

func _ready():
	fullscreen_check.button_pressed = Globals.fullscreen

func _on_return_pressed():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_configuration_pressed():
	buttons.visible = false
	config_buttons.visible = true

func _on_back_pressed():
	buttons.visible = true
	config_buttons.visible = false

func _on_apply_pressed():
	Globals.fullscreen = fullscreen_check.button_pressed
	Globals.save_settings()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mainmenu.tscn")
