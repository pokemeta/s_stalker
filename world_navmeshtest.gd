extends Node3D

@onready var spawnpoints = $Pages
@onready var pagesobj = preload("res://pagetest.tscn")

func _ready():
	var arr = get_random_numbers(0, spawnpoints.get_child_count())
	for number in arr:
		var page = pagesobj.instantiate()
		spawnpoints.get_child(number).add_child(page)
		page.global_position = spawnpoints.get_child(number).global_position
	for spawnpoint in spawnpoints.get_children():
		if not spawnpoint.has_node("Pagetest"):
			spawnpoint.queue_free()

func get_random_numbers(from, to):
	var arr = []
	for i in range(from,to):
		arr.append(i)
	arr.shuffle()
	return arr.slice(0, 8)
