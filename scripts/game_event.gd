extends Node

signal experience_vial_collected(number: float)
signal ability_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary)

func emit_experience_vial_collected(number: float) -> void:
	experience_vial_collected.emit(number)
	
func emit_ability_upgrade_addded(upgrade: AbilityUpgrade, current_upgrade: Dictionary):
	ability_added.emit(upgrade, current_upgrade)
