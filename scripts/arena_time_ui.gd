extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $%Label

func _process(_delta: float) -> void:
	if arena_time_manager == null:
		return

	var time_elapse = arena_time_manager.get_time_elapse()
	label.text = format_seconds_to_string(time_elapse)

func format_seconds_to_string(seconds: float) -> String:
	var minutes = floori(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
