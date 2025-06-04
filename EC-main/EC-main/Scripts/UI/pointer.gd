extends TextureRect

var curr_position: Vector2

func _ready() -> void:
	_initialize_pointer()
	_initialize_signals()

func _initialize_pointer() -> void:
	curr_position = position

func _initialize_signals() -> void:
	EventBus.add_signal("point_cursor", point_cursor)

func point_cursor(pos_x: float, pos_y: float, rot: float) -> void:
	curr_position = Vector2(pos_x, pos_y)
	position = curr_position
	rotation = deg_to_rad(rot)

func on_resolution_change() -> void:
	position = curr_position * get_viewport_rect().size / get_parent().size
