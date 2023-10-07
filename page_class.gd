extends StaticBody3D

class_name page_object

signal destroy_page

@onready var playercontroller = $"../Playercontroller"

func _process(_delta):
	
	var distance_x = playercontroller.global_position.x - self.global_position.x
	if distance_x <= 2:
		playercontroller.is_close_to_page = true
	else:
		playercontroller.is_close_to_page = false


func _on_destroy_page():
	self.queue_free()
