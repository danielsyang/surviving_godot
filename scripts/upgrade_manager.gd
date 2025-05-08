extends Node

# @export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrade = {}
var upgrade_pool = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe_weapon.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")

func _ready() -> void:
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)

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
			upgrade_pool.remove_item(chosen_upgrade)

	update_upgrade_pool(chosen_upgrade)
	GameEvent.emit_ability_upgrade_addded(chosen_upgrade, current_upgrade)

func pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []

	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break

		var chosen_upgrade = upgrade_pool.pick_random_item(chosen_upgrades);
		chosen_upgrades.append(chosen_upgrade)

	return chosen_upgrades

func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
	pass

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)

func on_level_up(_current_level: int):
	var chosen_upgrades = pick_upgrades()

	chosen_upgrades = chosen_upgrades.filter(func(upgrade: AbilityUpgrade):
		return upgrade != null
	)
	
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrade(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
