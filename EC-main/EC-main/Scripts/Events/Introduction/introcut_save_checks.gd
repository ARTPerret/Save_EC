extends Node2D

@export var timeline: String

func initialize() -> void:
	get_parent().player.visible = false
	Dialogic.start(timeline)
