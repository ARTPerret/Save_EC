extends Camera2D

var target: Node2D

func _physics_process(_delta: float) -> void:
	position = target.position

func set_limits(left: int, right: int, top: int, bottom: int):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
