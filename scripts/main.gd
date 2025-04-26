extends Node

@export var end_screen: PackedScene
@onready var player: CharacterBody2D = %Player

func _ready() -> void:
    player.health_component.died.connect(on_player_died)


func on_player_died() -> void:
    var end_screen_instance = end_screen.instantiate()
    add_child(end_screen_instance)
    end_screen_instance.set_defeat()
