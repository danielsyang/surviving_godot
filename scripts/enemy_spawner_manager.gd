extends Node

const SPAWN_RADIUS = 330

@export var basic_enemy_scene: PackedScene

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timout)
	
func on_timer_timout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return
		
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + random_direction * SPAWN_RADIUS

	var entities_layer = get_tree().get_first_node_in_group("entities_layer") as Node2D
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	enemy.global_position = spawn_position

	entities_layer.add_child(enemy)
