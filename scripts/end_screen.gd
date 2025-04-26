extends CanvasLayer
class_name EndScreen

@onready var restart_button: Button = %Restart
@onready var quit_button: Button = %Quit
@onready var title_label: Label = %Title
@onready var description_label: Label = %Description

func _ready() -> void:
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func set_defeat() -> void:
	title_label.text = "Defeat"
	description_label.text = "You lost."

func on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func on_quit_button_pressed() -> void:
	get_tree().quit()
