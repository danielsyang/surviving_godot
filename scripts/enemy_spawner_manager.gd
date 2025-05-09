extends Node

const SPAWN_RADIUS = 330


@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var base_spawn_time: float = 0.0
var enemy_table = WeightedTable.new()

func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return Vector2.ZERO

	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in 4:
		spawn_position = player.global_position + random_direction * SPAWN_RADIUS

		var query = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query)

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position
		

func on_timer_timout() -> void:
	timer.start()

	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D

	var t = enemy_table.pick_random_item()
	var enemy = enemy_table.pick_random_item().instantiate() as Node2D
	enemy.global_position = get_spawn_position()

	entities_layer.add_child(enemy)

func on_arena_difficulty_increased(new_difficulty: int) -> void:
	var time_off = min((.1 / 12) * new_difficulty, .7)
	timer.wait_time = base_spawn_time - time_off

	if new_difficulty == 1:
		enemy_table.add_item(wizard_enemy_scene, 30)
