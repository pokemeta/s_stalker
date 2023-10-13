extends Node3D

@onready var animation_player = $Static/static_anim
@onready var radio_sound = $radio_sound
@onready var blackscreen = $Static/blackscreen

var duration = 420
var time_passed = 0
var del = 0
var is_delayed = true
var already_activated = false

var second_del = 60

func _process(_delta):
	if del <= 60 and not already_activated:
		del += 1
	elif not already_activated:
		is_delayed = false
		already_activated = true
	
	if not is_delayed:
		blackscreen.visible = false
		animation_player.play("static")
		radio_sound.play(2.0)
		is_delayed = true
	
	if time_passed <= duration:
		time_passed += 1
	else:
		blackscreen.visible = true
		if second_del <= 120:
			second_del += 1
		else:
			get_tree().change_scene_to_file("res://retryscreen.tscn")
