extends Control

@onready var pagetext = $Pagetext

func _ready():
	pagetext.text = "Pages " + str(Globals.pages_collected) + " / 8 collected"

func _on_button_pressed():
	Globals.pages_collected = 0
	get_tree().change_scene_to_file("res://world_navmeshtest.tscn")
