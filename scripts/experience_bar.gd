extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar: ProgressBar = %ProgressBar

func _ready() -> void:
	progress_bar.value = 0
	experience_manager.experience_update.connect(on_experience_update)
	
func on_experience_update(current_experience: float, target_experience: float):
	var percentage = current_experience / target_experience
	progress_bar.value = percentage
