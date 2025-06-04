extends Node2D
class_name UIMap

@export var conclusion_panel: PanelContainer

var start_id: int = 0

func _ready() -> void:
	initialize_scene()

func initialize_scene() -> void:
	EventBus.emit_signal("set_ui_visibility", false)
	FadeManager.trigger_fade(0, 0.25, 3)
	
	if start_id == 0:
		conclusion_panel.title_panel.text = "Fin de la partie"
