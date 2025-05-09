extends Node

signal experience_update(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_UPGRADE = 5

var current_experience = 0
var current_level = 1
var target_experience = 1


func _ready() -> void:
	GameEvent.experience_vial_collected.connect(on_experience_vial_collected)

func increment_experience(number: float) -> void:
	current_experience = min(current_experience + number, target_experience) 
	experience_update.emit(current_experience, target_experience)
	
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_UPGRADE
		current_experience = 0
		experience_update.emit(current_experience, target_experience)
		level_up.emit(current_level)

func on_experience_vial_collected(number: float):
	increment_experience(number)
