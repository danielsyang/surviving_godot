extends Node2D

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D


func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)

func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null:
		return

	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = global_position - start_position
	var target_rotation_degrees = rad_to_deg(direction_from_start.angle()) + 90

	rotation_degrees = lerp(rotation_degrees, target_rotation_degrees, 1 - exp(-get_process_delta_time()))

func collect():
	GameEvent.emit_experience_vial_collected(1);
	queue_free()

func disable_collision():
	collision_shape.disabled = true

func on_area_entered(_other_area: Area2D):
	Callable(disable_collision).call_deferred()
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK);
	tween.tween_callback(collect)
