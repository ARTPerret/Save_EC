extends Control

@onready var maps: Resource = preload("uid://byrvrkqe18ml0")

var map_list: Dictionary[int,String]

var current_map : String = ""

@onready var ver_button = $Rows/Versioning
@onready var line_edit = $Rows/LineEdit
@onready var map_options = $Rows/MapDebug

func _ready() -> void:
	initialize_debug_tools()
	initialize_map_list()
	intialize_versionning()

func initialize_debug_tools() -> void:
	if !OS.is_debug_build():
		queue_free()

func initialize_map_list() -> void:
	var num: int = 0
	for key in maps.locations.keys():
		map_list[num] = key
		map_options.add_item(key, num)
		num += 1

func intialize_versionning() -> void:
	ver_button.text = ProjectSettings.get_setting("application/config/version")

#region VERSIONNING BUTTON
func _on_button_pressed() -> void:
	DisplayServer.clipboard_set(ProjectSettings.get_setting("application/config/version"))
#endregion

#region SCORE MODIFIER
func _on_line_edit_text_submitted(new_score: String) -> void:
	EventBus.emit_signal("set_empreinte", float(new_score))
	line_edit.text = ""
#endregion

#region SCENE TELEPORTER
func _on_option_button_item_selected(index: int) -> void:
	ThreadLoad.load_scene(map_list[index])
	current_map = map_list[index]

func _on_respawn_debug_item_selected(index: int) -> void:
	ThreadLoad.load_scene(current_map, index)
#endregion
