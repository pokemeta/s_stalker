extends StaticBody3D

class_name page_object

signal destroy_page

@export var playercontroller: Node3D

func _on_destroy_page():
	self.queue_free()

func _on_area_3d_body_entered(body):
	if body == playercontroller:
		playercontroller.is_close_to_page = true

func _on_area_3d_body_exited(body):
	if body == playercontroller:
		playercontroller.is_close_to_page = false
