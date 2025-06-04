extends Node2D
class_name Minigame

@export var end_timeline: String
@export var bookmark: int

var minigame_manager: Control

func get_window_size() -> Vector2:
	return $WindowSize.size

func quit_minigame() -> void:
	minigame_manager.erase_minigame(end_timeline, bookmark)
