extends Node2D

@export var loading_screens: Resource
var next_scene: Node2D
var loading_screen_key: String

func _ready() -> void:
	initialize_loading_screen()
	initialize_load_type()

func initialize_loading_screen() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

func initialize_load_type() -> void:
	EventBus.emit_signal("set_ui_visibility", false)
	if loading_screen_key.is_empty():
		# Chargement rapide sans écran de chargement
		_on_event_trigger()
	else:
		# Chargement avec un écran de chargement
		if AudioManager.is_same_music(next_scene.music):
			AudioManager.fade_music(-80, 3.0)
		
		FadeManager.visible = false
		var load_trans: Node2D = load(loading_screens.types[loading_screen_key]).instantiate()
		add_child(load_trans)

func _on_event_trigger() -> void:
	FadeManager.visible = true
	ThreadLoad.trigger_next_scene(next_scene)
