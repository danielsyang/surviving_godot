extends Node

@export var axe_ability_scene: PackedScene

var damage = 10
var additional_damage = 1

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	GameEvent.ability_added.connect(on_ability_upgrade_added)

func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return

	var axe_instance = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)

	axe_instance.global_position = player.global_position
	axe_instance.hitboxComponent.damage = damage * additional_damage

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary) -> void:
	if upgrade.id == "axe_damage":
		additional_damage = 1 + (current_upgrade["axe_damage"]["quantity"] * .3)
