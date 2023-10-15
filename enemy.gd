extends CharacterBody3D

@onready var playercontroller = $"../Playercontroller"

var on_view = false

# For movements of the enemy
@onready var nav_agent = $NavigationAgent3D
var speed = 25.0

# This timer is set because the nav_agent throws an error
# due to "not sincronizing the map" on time, so a delay
# is set here
var init_timer = 0

# Teleport vars
@export var teleport_points: Array[Node3D]
var teleport_delay_timer = 660 
var delay_teleport = 0
var selected_number
var minDistance = 50.0
var maxDistance = 100.0

signal increment_agressiveness

func _physics_process(delta):
	check_floor()
	
	if not playercontroller.is_caught:
		teleport()

	player_on_sight(delta)

# Floor detection to snap to floor in-game
func check_floor():
	if not is_on_floor():
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.create(global_position, Vector3(0, -500, 0))
		var results = space.intersect_ray(ray_query)
		if results:
			#print(results.position)
			global_position = results.position
			global_position.y += 1

func player_on_sight(delta):
	var space = get_world_3d().direct_space_state
	var ray_to_player = PhysicsRayQueryParameters3D.create(
		global_position, playercontroller.global_position
	)
	var results = space.intersect_ray(ray_to_player)
	
	if results:
		if results.collider == playercontroller and on_view:
			playercontroller.emit_signal("set_view_true")
		else:
			ai_move(delta)
			playercontroller.emit_signal("set_view_false")

func teleport():
	if delay_teleport <= teleport_delay_timer:
		delay_teleport += 1
	else:
		var playerPos = playercontroller.transform.origin
		var newX = playerPos.x + randf_range(-maxDistance, maxDistance)
		var newZ = playerPos.z + randf_range(-maxDistance, maxDistance)
		var newPos = Vector3(newX, transform.origin.y, newZ)
		transform.origin = newPos
		delay_teleport = 0

func ai_move(delta):
	nav_agent.set_target_position(playercontroller.global_position)
	
	if init_timer <= 60:
		init_timer += 1
	else:
		var current_location = global_position
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed * delta
	
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()

func aggresive_increment():
	teleport_delay_timer -= 60
	match playercontroller.pages:
		3:
			speed *= 4
			minDistance /= 2
			maxDistance /= 2
		6:
			speed *= 4
			minDistance /= 5
			maxDistance /= 5

func _on_visible_on_screen_notifier_3d_screen_entered():
	on_view = true

func _on_visible_on_screen_notifier_3d_screen_exited():
	on_view = false

func _on_area_3d_body_entered(body):
	if body == playercontroller:
		playercontroller.emit_signal("on_caught")

func _on_increment_agressiveness():
	aggresive_increment()
