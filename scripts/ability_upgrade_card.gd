extends PanelContainer

signal selected

@onready var description: Label = %Description
@onready var title: Label = %Title

func _ready() -> void:
	gui_input.connect(on_gui_input)

func set_ability_upgrade(upgrade: AbilityUpgrade):
	title.text = upgrade.name
	description.text = upgrade.description

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("mouse_left_click"):
		selected.emit()
