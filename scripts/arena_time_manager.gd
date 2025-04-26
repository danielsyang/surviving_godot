extends Node

signal arena_difficulty_increased(new_difficulty: int)

const DIFFICULTY_INTERVAL: float = 5.0

@export var end_screen: PackedScene

@onready var timer = $Timer
var arena_difficulty: int = 0
var previous_time: float = 0

func _ready():
	timer.timeout.connect(on_timer_timeout)

func _process(_delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)

	if timer.time_left < next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)

func on_timer_timeout():
	var end_screen_instance = end_screen.instantiate()

	# end_screen_instance
	
	get_tree().current_scene.add_child(end_screen_instance)

func get_time_elapse():
	return timer.wait_time - timer.time_left
