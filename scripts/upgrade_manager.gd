extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrade = {}

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)
	
func apply_upgrade(chosen_upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrade.has(chosen_upgrade.id)
	
	if not has_upgrade:
		current_upgrade[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1
		}
	else:
		current_upgrade[chosen_upgrade.id]["quantity"] += 1
	
	if chosen_upgrade.max_quantity > 0:
		var current_quantity = current_upgrade[chosen_upgrade.id]["quantity"]

		if current_quantity == chosen_upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func(upgrade: AbilityUpgrade):
				return upgrade.id != chosen_upgrade.id
			)

	GameEvent.emit_ability_upgrade_addded(chosen_upgrade, current_upgrade)

func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()

	for i in upgrade_pool.size():
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func(filtered_upgrade: AbilityUpgrade):
			return filtered_upgrade.id != chosen_upgrade.id
		)

	return chosen_upgrades

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

func on_level_up(_current_level: int):
	var chosen_upgrades = pick_upgrades()
	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrade(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
