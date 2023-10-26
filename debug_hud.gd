extends Control

# The necessary vars to read the data for labels
@onready var enemy = $"../Enemy"
@onready var playercontroller = $"../Playercontroller"
@onready var tv_static = $"../Playercontroller/HUD/Tv_static"

# The labels themselves
@onready var active_state = $VBoxContainer/Active_state
@onready var enemyposition = $VBoxContainer/Enemyposition
@onready var timer_total = $VBoxContainer/Timer_total
@onready var timer_counter = $VBoxContainer/Timer_counter

@onready var pages_count = $VBoxContainer/Pages_count
@onready var tvstatic_opacity = $VBoxContainer/tvstatic_opacity

@onready var fps_counter = $VBoxContainer/FPS_counter
var fps = 0

func _process(_delta):
	fps = str(Engine.get_frames_per_second())
	active_state.text = "Active: " + str(enemy.active)
	enemyposition.text = "Position: " + str(enemy.global_position)
	timer_total.text = "Current teleport timer delay: " + str(enemy.teleport_delay_timer)
	timer_counter.text = "Current timer teleport counter: " + str(enemy.delay_teleport)
	
	pages_count.text = "Pages: " + str(playercontroller.pages)
	tvstatic_opacity.text = "Static opacity: " + str(tv_static.self_modulate.a)
	
	fps_counter.text = "FPS: " + fps
	
