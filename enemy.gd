extends CharacterBody3D

@onready var playercontroller = $"../Playercontroller"

var on_view = false

# For movements of the enemy
@onready var nav_agent = $NavigationAgent3D
var speed = 3.0

# This timer is set because the nav_agent throws an error
# due to "not sincronizing the map" on time, so a delay
# is set here
var init_timer = 0

# Teleport vars
@export var teleport_points: Array[Node3D]
var delay_teleport = 0
var selected_number

func _physics_process(_delta):
	
	if not playercontroller.is_caught:
		teleport()
	
	player_on_sight()

func player_on_sight():
	var space = get_world_3d().direct_space_state
	var ray_to_player = PhysicsRayQueryParameters3D.create(
		global_position, playercontroller.global_position
	)
	var results = space.intersect_ray(ray_to_player)
	
	if results:
		if results.collider == playercontroller and on_view:
			playercontroller.emit_signal("set_view_true")
		else:
			ai_move()
			playercontroller.emit_signal("set_view_false")

func teleport():
	if delay_teleport <= 720:
		delay_teleport += 1
	else:
		var randomizer = randf_range(0, teleport_points.size())
		while randomizer == selected_number:
			randomizer = randf_range(0, teleport_points.size())
		selected_number = randomizer
		global_position = teleport_points[randomizer].global_position
		global_position.y += 1
		delay_teleport = 0

func ai_move():
	nav_agent.set_target_position(playercontroller.global_position)
	
	if init_timer <= 60:
		init_timer += 1
	else:
		var current_location = global_position
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
	
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_entered():
	on_view = true

func _on_visible_on_screen_notifier_3d_screen_exited():
	on_view = false


func _on_area_3d_body_entered(body):
	if body == playercontroller:
		playercontroller.emit_signal("on_caught")
