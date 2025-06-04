extends PanelContainer

@export var new_game_panel: PanelContainer

func _ready() -> void:
	intialize_pause()

func intialize_pause() -> void:
	visible = false
	EventBus.add_signal("set_pause", _on_unpause_pressed)

func _on_unpause_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		visible = false
		new_game_panel.visible = false
		EventBus.emit_signal("set_ui_visibility", true)
	else :
		get_tree().paused = true
		visible = true
		EventBus.emit_signal("set_ui_visibility", false)

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_sprint_toggle_toggled(toggled_on: bool) -> void:
	Game.inputs.toggleable_sprint = toggled_on

func _on_v_sync_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_slider_sfx_value_changed(value: float) -> void:
	AudioManager.set_bus(2, value)

func _on_slider_music_value_changed(value: float) -> void:
	AudioManager.set_bus(1, value)

func _on_new_game_pressed() -> void:
	SaveManager.deleteSave()
	EventBus.emit_signal("clear_items")
	EventBus.emit_signal("clean_quests")
	EventBus.emit_signal("reset_time")
	ThreadLoad.load_scene("Journalistes")
	new_game_panel.visible = false
	_on_unpause_pressed()

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
