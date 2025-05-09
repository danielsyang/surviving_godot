extends CharacterBody2D

const SPEED = 200
const ACCELERATION_SMOOTHING = 5

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilityManager: Node = $AbilityManager
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals


var number_colliding_bodies: int = 0

func _ready() -> void:
	$HurtboxArea.body_entered.connect(on_body_entered)
	$HurtboxArea.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	health_bar.value = 1

	GameEvent.ability_added.connect(on_ability_upgrade_added)

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = SPEED * direction
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()

	if movement_vector.x != 0 || movement_vector.y != 0:
		animationPlayer.play("walk")
	else:
		animationPlayer.play("RESET")
	
	if movement_vector.x != 0:
		visuals.scale = Vector2(-movement_vector.x, 1)

func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)

func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return

	health_component.take_damage(1)
	damage_interval_timer.start()

func update_health_bar_display() -> void:
	health_bar.value = health_component.get_health_percentage()

func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()

func on_body_entered(_other_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(_other_body: Node2D) -> void:
	number_colliding_bodies -= 1

func on_health_changed() -> void:
	update_health_bar_display()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, _current_upgrade: Dictionary) -> void:
	if not upgrade is Ability:
		return

	var ability_upgrade = upgrade as Ability
	abilityManager.add_child(ability_upgrade.ability_controller_scene.instantiate())
