extends Node2D

func _on_animation_finished(_anim_name: StringName) -> void:
	get_parent()._on_event_trigger()
