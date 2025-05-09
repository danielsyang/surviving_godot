extends PanelContainer

signal selected

@onready var description: Label = %Description
@onready var title: Label = %Title

var disabled = false

func _ready() -> void:
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	title.text = upgrade.name
	description.text = upgrade.description

func play_discard():
	$AnimationPlayer.play("discard")

func play_selected():
	disabled = true
	$AnimationPlayer.play("selected")
	await $AnimationPlayer.animation_finished
	selected.emit()

func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	modulate = Color.WHITE
	$AnimationPlayer.play("in")

func on_gui_input(event: InputEvent):
	if disabled:
		return

	if event.is_action_pressed("mouse_left_click"):
		play_selected()

func on_mouse_entered():
	if disabled:
		return

	$HoverAnimation.play("hover")
