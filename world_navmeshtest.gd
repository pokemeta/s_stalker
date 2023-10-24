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
	var selects = []
	var total = []
	for i in range(from,to):
		arr.append(i)
	#arr.shuffle()
	
	for i in arr.size():
		#print(arr[i])
		selects.append(arr[i])
		if i % 3 == 0:
			total.append(selects.pick_random())
			selects.clear()
	
	#print(total)
	
	#return arr.slice(0, 8)
	return total
