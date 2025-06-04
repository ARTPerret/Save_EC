extends Node

@onready var sprite: Sprite2D = $Sprite2D

func _on_mouse_hover(arg: float) -> void:
	sprite.material.set_shader_parameter("width",arg)
