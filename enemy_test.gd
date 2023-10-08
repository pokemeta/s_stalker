extends CharacterBody3D

@onready var playercontroller = $"../Playercontroller"

var on_view = false

func _physics_process(_delta):
	var space = get_world_3d().direct_space_state
	var ray_to_player = PhysicsRayQueryParameters3D.create(
		global_position, playercontroller.global_position
	)
	var results = space.intersect_ray(ray_to_player)
	
	if results:
		if results.collider == playercontroller and on_view:
			playercontroller.emit_signal("set_view_true")
		else:
			playercontroller.emit_signal("set_view_false")

func _on_visible_on_screen_notifier_3d_screen_entered():
	on_view = true


func _on_visible_on_screen_notifier_3d_screen_exited():
	on_view = false
