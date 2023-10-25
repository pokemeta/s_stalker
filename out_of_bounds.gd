extends Control

@onready var animation_player = $AnimationPlayer

signal trigger_out_warning

func _on_trigger_out_warning():
	animation_player.play("fade")

func kill_player():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://deathscreen.tscn")
