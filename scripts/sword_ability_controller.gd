extends Node

const MAX_RANGE = 200

@export var sword_ability: PackedScene

var damage = 50;
var base_wait_time = 1.5

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)
	base_wait_time = $Timer.wait_time
	GameEvent.ability_added.connect(on_ability_upgrade_added)


func on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var enemies = get_tree().get_nodes_in_group("enemy")

	enemies = enemies.filter(func(enemy: Node2D) -> bool:
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		
		return a_distance < b_distance
	)

	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D

	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage
	
	var closest_enemy = enemies[0]
	
	if closest_enemy == null:
		return
	
	sword_instance.global_position = closest_enemy.global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction = closest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary) -> void:
	if upgrade.id != "sword_rate":
		return

	var sword_rate_upgrade: float = current_upgrade.get(upgrade.id, {}).quantity || 1.0
	var percent_reduction = sword_rate_upgrade * .3;

	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	$Timer.start()

	
