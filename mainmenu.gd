extends Control

@onready var main_container = $Main_container
@onready var config_container = $Config_container

@onready var fullscreen_check = $Config_container/Fullscreen_check

@onready var bg_menu = $BG_menu

func _ready():
	fullscreen_check.button_pressed = Globals.fullscreen
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

func _on_apply_button_pressed():
	Globals.fullscreen = fullscreen_check.button_pressed
	Globals.save_settings()
