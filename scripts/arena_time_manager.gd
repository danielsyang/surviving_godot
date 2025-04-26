extends Node

@export var end_screen: PackedScene

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	var end_screen_instance = end_screen.instantiate()

	# end_screen_instance
	
	get_tree().current_scene.add_child(end_screen_instance)

func get_time_elapse():
	return timer.wait_time - timer.time_left
