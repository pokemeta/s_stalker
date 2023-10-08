extends CharacterBody3D

# Signals to handle the change of seeing the enemy
signal set_view_true
signal set_view_false

# Variables for movement speed
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5

# Mouse sensitvity
const SENSITIVITY = 0.003

# Object variables to move the camera
@onready var camera = $Head/Camera3D
@onready var head = $Head

# Head bob variables
const BOB_FREQUENCY = 2.0
const BOB_AMPLITUDE = 0.08
var t_bob = 0.0

# FOV variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# Shapecast, used to help with the visibility of the enemy
@onready var shapecast = $Head/Camera3D/ShapeCast3D
@export var enemy: Node3D

# Variable that is used to detect if the enemy is on view
var player_is_seeing_it = false

# HUD vars, needed for the static itself
@onready var tv_static = $HUD/Tv_static
@onready var tv_static_anim = $tv_static_anim
@onready var radio_sound = $radio_sound

# Variable that gets changed by page_class script
var is_close_to_page = false
@onready var press_e = $HUD/Press_e
@onready var pages_sound = $pages_sound

# Pages
var pages = 0
@onready var p_fade_animation = $HUD/pagecount_fade
@onready var page_count = $HUD/page_count
@onready var pagecast = $Head/Camera3D/Pagecast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	tv_static_anim.play("tv_static")
	
	# This is done because the raycast would always detect the player
	shapecast.add_exception(self)
	pagecast.add_exception(self)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	if pagecast.is_colliding():
		if pagecast.get_collider(0) is page_object and is_close_to_page:
			press_e.visible = true
			if Input.is_action_just_pressed("interact"):
				press_e.visible = false
				collected_page()
				pagecast.get_collider(0).emit_signal("destroy_page")
	else:
		press_e.visible = false
	
	if is_seeing_the_enemy():
		if not radio_sound.playing:
			radio_sound.play()
		
		if radio_sound.volume_db <= -20:
			radio_sound.volume_db += 0.01
		
		if tv_static.self_modulate.a < 1:
			tv_static.self_modulate.a += 0.001
	else:
		if radio_sound.volume_db >= -30:
			radio_sound.volume_db -= 0.1
		else:
			radio_sound.stop()
			
		if tv_static.self_modulate.a > 0:
			tv_static.self_modulate.a -= 0.01
		
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bobbing
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2.0)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func collected_page():
	pages_sound.play()
	pages += 1
	var page_string = str(pages)
	page_count.text = "Pages " + page_string + " out of 8 collected"
	p_fade_animation.play("p_fade")

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = sin(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos


func is_seeing_the_enemy():
	if player_is_seeing_it:
		return true

	if shapecast.is_colliding():
		if shapecast.get_collider(0) == enemy:
			return true

	return false

func _on_set_view_true():
	player_is_seeing_it = true


func _on_set_view_false():
	player_is_seeing_it = false
