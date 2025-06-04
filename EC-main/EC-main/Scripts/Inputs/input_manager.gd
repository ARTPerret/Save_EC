extends Control
class_name InputManager

var toggleable_sprint: bool = false

func get_direction() -> Vector2:
	return Vector2.ZERO

func is_sprinting() -> bool:
	return false

func is_interacting() -> bool:
	return false
